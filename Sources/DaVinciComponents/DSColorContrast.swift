import SwiftUI
import UIKit

internal enum DSColorContrast {
    @MainActor
    static func ratio(
        foreground: Color,
        background: Color,
        colorScheme: ColorScheme
    ) -> Double? {
        guard let foregroundLuminance = luminance(of: foreground, colorScheme: colorScheme),
              let backgroundLuminance = luminance(of: background, colorScheme: colorScheme) else {
            return nil
        }
        let lighter = max(foregroundLuminance, backgroundLuminance)
        let darker = min(foregroundLuminance, backgroundLuminance)
        return (lighter + 0.05) / (darker + 0.05)
    }

    @MainActor
    static func preferredForeground(
        on background: Color,
        candidates: [Color],
        colorScheme: ColorScheme
    ) -> Color {
        candidates.max { first, second in
            let firstRatio = ratio(
                foreground: first,
                background: background,
                colorScheme: colorScheme
            ) ?? 0
            let secondRatio = ratio(
                foreground: second,
                background: background,
                colorScheme: colorScheme
            ) ?? 0
            return firstRatio < secondRatio
        } ?? .primary
    }

    @MainActor
    private static func luminance(of color: Color, colorScheme: ColorScheme) -> Double? {
        let style: UIUserInterfaceStyle = colorScheme == .dark ? .dark : .light
        let resolvedColor = UIColor(color).resolvedColor(
            with: UITraitCollection(userInterfaceStyle: style)
        )
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard resolvedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha),
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
}
