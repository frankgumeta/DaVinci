import SwiftUI
import DaVinciTokens

// MARK: - GalleryHomeScreen

public struct GalleryHomeScreen: View {
    @Environment(\.dsTheme) private var theme
    @Binding var currentTheme: DSTheme
    @Binding var colorSchemeOverride: ColorScheme?

    public init(
        currentTheme: Binding<DSTheme>,
        colorSchemeOverride: Binding<ColorScheme?>
    ) {
        self._currentTheme = currentTheme
        self._colorSchemeOverride = colorSchemeOverride
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Tokens") {
                    NavigationLink("Colors") { ColorGalleryScreen() }
                    NavigationLink("Typography") { TypographyGalleryScreen() }
                    NavigationLink("Layout") { LayoutGalleryScreen() }
                    NavigationLink("Effects") { EffectsGalleryScreen() }
                }

                Section("Components") {
                    NavigationLink("Components") { ComponentsListScreen() }
                    NavigationLink("Skeletons") { SkeletonGalleryScreen() }
                }

                Section("Theme") {
                    themePicker
                }

                Section("Appearance") {
                    appearancePicker
                }
            }
            .navigationTitle("DaVinci Gallery")
        }
    }

    // MARK: - Theme Picker

    private var themePicker: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space2) {
            Text("Active Theme")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textSecondary)

            HStack(spacing: SpacingTokens.space3) {
                themeButton("Default", theme: .defaultTheme)
                themeButton("Alternate", theme: .alternate)
            }
        }
        .padding(.vertical, SpacingTokens.space1)
    }

    private func themeButton(_ label: String, theme target: DSTheme) -> some View {
        let isSelected = currentTheme.name == target.name
        return Button {
            withAnimation(.easeInOut(duration: theme.motion.normal)) {
                currentTheme = target
            }
        } label: {
            Text(label)
                .font(theme.typography.callout.font(family: theme.typography.family))
                .foregroundStyle(isSelected ? .white : theme.colors.semantic.textPrimary)
                .padding(.horizontal, SpacingTokens.space3)
                .padding(.vertical, SpacingTokens.space2)
                .background(isSelected ? theme.colors.brand.primary : theme.colors.semantic.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.small))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Appearance Picker

    private var appearancePicker: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space2) {
            Text("Color Scheme")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textSecondary)

            Picker("Appearance", selection: $colorSchemeOverride) {
                Text("System").tag(ColorScheme?.none)
                Text("Light").tag(ColorScheme?.some(.light))
                Text("Dark").tag(ColorScheme?.some(.dark))
            }
            .pickerStyle(.segmented)
        }
        .padding(.vertical, SpacingTokens.space1)
    }
}

// MARK: - Previews

#Preview("Gallery Home") {
    @Previewable @State var theme = DSTheme.defaultTheme
    @Previewable @State var scheme: ColorScheme? = nil
    GalleryHomeScreen(currentTheme: $theme, colorSchemeOverride: $scheme)
        .dsTheme(theme)
        .preferredColorScheme(scheme)
}

#Preview("Gallery Home — Dark") {
    @Previewable @State var theme = DSTheme.defaultTheme
    @Previewable @State var scheme: ColorScheme? = .dark
    GalleryHomeScreen(currentTheme: $theme, colorSchemeOverride: $scheme)
        .dsTheme(theme)
        .preferredColorScheme(scheme)
}

#Preview("Gallery Home — Alternate") {
    @Previewable @State var theme = DSTheme.alternate
    @Previewable @State var scheme: ColorScheme? = nil
    GalleryHomeScreen(currentTheme: $theme, colorSchemeOverride: $scheme)
        .dsTheme(theme)
        .preferredColorScheme(scheme)
}
