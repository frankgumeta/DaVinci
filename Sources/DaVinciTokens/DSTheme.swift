import SwiftUI

// MARK: - DSTheme

/// The root theme container for the DaVinci design system.
///
/// `DSTheme` is the central configuration object that holds all design tokens:
/// colors, typography, and motion parameters. It automatically adapts to light
/// and dark color schemes through its internal `DSPalette`.
///
/// ## Usage
///
/// Apply a theme to your view hierarchy using the `.dsTheme(_:)` modifier:
///
/// ```swift
/// ContentView()
///     .dsTheme(.defaultTheme)
/// ```
///
/// Components automatically read the theme from the environment:
///
/// ```swift
/// struct MyView: View {
///     @Environment(\.dsTheme) private var theme
///
///     var body: some View {
///         Text("Hello")
///             .foregroundColor(theme.colors.semantic.textPrimary)
///             .font(theme.typography.body.font(family: theme.typography.family))
///     }
/// }
/// ```
///
/// ## Custom Themes
///
/// Create custom themes by providing your own colors and typography:
///
/// ```swift
/// let customTheme = DSTheme(
///     name: "Purple",
///     colors: DSColors(
///         brand: BrandColors(primary: .purple)
///     )
/// )
/// ```
///
/// For advanced theming with separate light/dark palettes:
///
/// ```swift
/// let palette = DSPalette(
///     light: DSColors(/* light colors */),
///     dark: DSColors(/* dark colors */)
/// )
/// let theme = DSTheme(name: "Custom", palette: palette)
/// ```
///
/// - Note: The `.dsTheme(_:)` modifier automatically resolves colors based on the
///   current `ColorScheme`. Components never need to check the color scheme directly.
///
/// ## Topics
///
/// ### Creating Themes
/// - ``init(name:palette:typography:motion:)``
/// - ``init(name:colors:typography:motion:)``
///
/// ### Theme Properties
/// - ``name``
/// - ``colors``
/// - ``typography``
/// - ``motion``
/// - ``palette``
///
/// ### Default Theme
/// - ``defaultTheme``
///
/// ### Color Scheme Resolution
/// - ``resolved(for:)``
public struct DSTheme: Sendable {
    public let name: String
    public let palette: DSPalette
    public let colors: DSColors
    public let typography: DSTypography
    public let motion: DSMotion

    /// Full initializer with explicit palette.
    public init(
        name: String = "default",
        palette: DSPalette = .default,
        typography: DSTypography = DSTypography(),
        motion: DSMotion = DSMotion()
    ) {
        self.name = name
        self.palette = palette
        self.colors = palette.light
        self.typography = typography
        self.motion = motion
    }

    /// Convenience initializer for single-mode themes (no dark variant).
    public init(
        name: String = "default",
        colors: DSColors,
        typography: DSTypography = DSTypography(),
        motion: DSMotion = DSMotion()
    ) {
        self.name = name
        self.palette = DSPalette(uniform: colors)
        self.colors = colors
        self.typography = typography
        self.motion = motion
    }

    /// Returns a copy of this theme with colors resolved for the given scheme.
    public func resolved(for scheme: ColorScheme) -> DSTheme {
        DSTheme(
            name: name,
            palette: palette,
            resolvedColors: palette.resolved(for: scheme),
            typography: typography,
            motion: motion
        )
    }

    /// Private init used by `resolved(for:)` to set colors directly.
    private init(
        name: String,
        palette: DSPalette,
        resolvedColors: DSColors,
        typography: DSTypography,
        motion: DSMotion
    ) {
        self.name = name
        self.palette = palette
        self.colors = resolvedColors
        self.typography = typography
        self.motion = motion
    }
}

// MARK: - DefaultTheme

extension DSTheme {
    /// The built-in default theme with light and dark palettes.
    public static let defaultTheme = DSTheme()
}

// MARK: - SwiftUI Environment Integration

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue = DSTheme.defaultTheme
}

extension EnvironmentValues {
    /// The current theme applied to the view hierarchy.
    ///
    /// Access this value from within a view using `@Environment(\.dsTheme)`.
    /// Set it at the root of your view hierarchy using `.dsTheme(_:)`.
    public var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }
}

// MARK: - View Convenience

extension View {
    /// Inject a `DSTheme` into the view hierarchy.
    /// Automatically resolves the palette for the current `ColorScheme`.
    public func dsTheme(_ theme: DSTheme) -> some View {
        modifier(DSThemeResolver(theme: theme))
    }
}

// MARK: - DSThemeResolver

/// Internal modifier that reads `ColorScheme` and resolves the theme palette
/// before injecting it into the environment. Components only read
/// `@Environment(\.dsTheme)` and never need to know about `ColorScheme`.
private struct DSThemeResolver: ViewModifier {
    let theme: DSTheme
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .environment(\.dsTheme, theme.resolved(for: colorScheme))
    }
}
