import SwiftUI
import UIKit

/// A diagnostic emitted when a custom theme violates a DaVinci design contract.
public struct DSThemeValidationIssue: Equatable, Sendable {
    public enum Severity: String, Sendable {
        case warning
        case error
    }

    public enum Code: String, Sendable {
        case emptyName
        case insufficientContrast
        case invalidMotion
        case invalidTypography
        case unresolvedColor
    }

    public enum Scheme: String, Sendable {
        case light
        case dark
    }

    public let severity: Severity
    public let code: Code
    public let path: String
    public let scheme: Scheme?
    public let message: String

    public init(
        severity: Severity,
        code: Code,
        path: String,
        scheme: Scheme? = nil,
        message: String
    ) {
        self.severity = severity
        self.code = code
        self.path = path
        self.scheme = scheme
        self.message = message
    }
}

/// Validates custom themes before they are shipped by a host application.
///
/// Validation is deterministic and has no effect on rendering. Run it in tests,
/// debug assertions, or theme-authoring tools:
///
/// ```swift
/// let issues = DSThemeValidator.validate(customTheme)
/// precondition(issues.allSatisfy { $0.severity != .error })
/// ```
///
/// The validator checks theme identity, typography and motion ranges, WCAG text
/// contrast, and the primary accent outline. It does not certify an entire host
/// application or replace manual accessibility testing.
@MainActor
public enum DSThemeValidator {
    private static let normalTextMinimum = 4.5
    private static let nonTextMinimum = 3.0

    private struct ContrastCheck {
        let path: String
        let foreground: Color
        let background: Color
        let minimum: Double
    }

    /// Returns every issue found in the light and dark variants of `theme`.
    public static func validate(_ theme: DSTheme) -> [DSThemeValidationIssue] {
        var issues: [DSThemeValidationIssue] = []

        if theme.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            issues.append(
                issue(
                    code: .emptyName,
                    path: "name",
                    message: "Theme name must not be empty."
                )
            )
        }

        validateTypography(theme.typography, into: &issues)
        validateMotion(theme.motion, into: &issues)
        validateColors(theme.palette.light, scheme: .light, into: &issues)
        validateColors(theme.palette.dark, scheme: .dark, into: &issues)
        return issues
    }

    private static func validateTypography(
        _ typography: DSTypography,
        into issues: inout [DSThemeValidationIssue]
    ) {
        let styles: [(String, DSTextStyle)] = [
            ("display", typography.display),
            ("title", typography.title),
            ("headline", typography.headline),
            ("body", typography.body),
            ("callout", typography.callout),
            ("caption", typography.caption),
            ("overline", typography.overline)
        ]

        for (name, style) in styles {
            if !style.size.isFinite || style.size <= 0 {
                issues.append(
                    issue(
                        code: .invalidTypography,
                        path: "typography.\(name).size",
                        message: "Typography size must be finite and greater than zero."
                    )
                )
            }
            if !style.lineHeight.isFinite || style.lineHeight < style.size {
                issues.append(
                    issue(
                        code: .invalidTypography,
                        path: "typography.\(name).lineHeight",
                        message: "Line height must be finite and at least the font size."
                    )
                )
            }
        }
    }

    private static func validateMotion(
        _ motion: DSMotion,
        into issues: inout [DSThemeValidationIssue]
    ) {
        let durations = [
            ("fast", motion.fast),
            ("normal", motion.normal),
            ("slow", motion.slow),
            ("shimmerDuration", motion.shimmerDuration)
        ]

        for (name, duration) in durations where !duration.isFinite || duration < 0 {
            issues.append(
                issue(
                    code: .invalidMotion,
                    path: "motion.\(name)",
                    message: "Motion durations must be finite and nonnegative."
                )
            )
        }
    }

    private static func validateColors(
        _ colors: DSColors,
        scheme: DSThemeValidationIssue.Scheme,
        into issues: inout [DSThemeValidationIssue]
    ) {
        let semantic = colors.semantic
        for pair in textContrastChecks(colors) {
            validateContrast(pair, scheme: scheme, into: &issues)
        }

        validateContrast(
            ContrastCheck(
                path: "accent.strokeAccent/semantic.bgPrimary",
                foreground: colors.accent.strokeAccent,
                background: semantic.bgPrimary,
                minimum: nonTextMinimum
            ),
            scheme: scheme,
            into: &issues
        )
    }

    private static func textContrastChecks(_ colors: DSColors) -> [ContrastCheck] {
        let semantic = colors.semantic
        return [
            ContrastCheck(
                path: "semantic.textPrimary/bgPrimary",
                foreground: semantic.textPrimary,
                background: semantic.bgPrimary,
                minimum: normalTextMinimum
            ),
            ContrastCheck(
                path: "semantic.textSecondary/bgPrimary",
                foreground: semantic.textSecondary,
                background: semantic.bgPrimary,
                minimum: normalTextMinimum
            ),
            ContrastCheck(
                path: "semantic.textTertiary/bgPrimary",
                foreground: semantic.textTertiary,
                background: semantic.bgPrimary,
                minimum: normalTextMinimum
            ),
            ContrastCheck(
                path: "semantic.textPrimary/surfacePrimary",
                foreground: semantic.textPrimary,
                background: semantic.surfacePrimary,
                minimum: normalTextMinimum
            ),
            ContrastCheck(
                path: "semantic.textSecondary/surfacePrimary",
                foreground: semantic.textSecondary,
                background: semantic.surfacePrimary,
                minimum: normalTextMinimum
            ),
            ContrastCheck(
                path: "semantic.textOnBrand/brand.primary",
                foreground: semantic.textOnBrand,
                background: colors.brand.primary,
                minimum: normalTextMinimum
            )
        ]
    }

    private static func validateContrast(
        _ check: ContrastCheck,
        scheme: DSThemeValidationIssue.Scheme,
        into issues: inout [DSThemeValidationIssue]
    ) {
        guard let ratio = contrastRatio(
            foreground: check.foreground,
            background: check.background,
            scheme: scheme
        ) else {
            issues.append(
                issue(
                    severity: .warning,
                    code: .unresolvedColor,
                    path: check.path,
                    scheme: scheme,
                    message: "Color pair could not be resolved to opaque sRGB values."
                )
            )
            return
        }

        if ratio < check.minimum {
            issues.append(
                issue(
                    code: .insufficientContrast,
                    path: check.path,
                    scheme: scheme,
                    message: String(
                        format: "Contrast %.2f:1 is below the required %.1f:1.",
                        ratio,
                        check.minimum
                    )
                )
            )
        }
    }

    private static func contrastRatio(
        foreground: Color,
        background: Color,
        scheme: DSThemeValidationIssue.Scheme
    ) -> Double? {
        let interfaceStyle: UIUserInterfaceStyle = scheme == .dark ? .dark : .light
        let traits = UITraitCollection(userInterfaceStyle: interfaceStyle)
        guard let foregroundLuminance = luminance(foreground, traits: traits),
              let backgroundLuminance = luminance(background, traits: traits) else {
            return nil
        }
        let lighter = max(foregroundLuminance, backgroundLuminance)
        let darker = min(foregroundLuminance, backgroundLuminance)
        return (lighter + 0.05) / (darker + 0.05)
    }

    private static func luminance(_ color: Color, traits: UITraitCollection) -> Double? {
        let resolved = UIColor(color).resolvedColor(with: traits)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard resolved.getRed(&red, green: &green, blue: &blue, alpha: &alpha),
              alpha == 1 else {
            return nil
        }

        func linearize(_ channel: CGFloat) -> Double {
            let value = Double(channel)
            return value <= 0.04045
                ? value / 12.92
                : pow((value + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * linearize(red)
            + 0.7152 * linearize(green)
            + 0.0722 * linearize(blue)
    }

    private static func issue(
        severity: DSThemeValidationIssue.Severity = .error,
        code: DSThemeValidationIssue.Code,
        path: String,
        scheme: DSThemeValidationIssue.Scheme? = nil,
        message: String
    ) -> DSThemeValidationIssue {
        DSThemeValidationIssue(
            severity: severity,
            code: code,
            path: path,
            scheme: scheme,
            message: message
        )
    }
}
