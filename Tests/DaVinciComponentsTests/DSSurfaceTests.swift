import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSSurface")
struct DSSurfaceTests {

    private let theme = DSTheme.defaultTheme

    // MARK: - Fill Resolution

    @Test func semanticFillsResolveToThemeColors() {
        let semantic = theme.colors.semantic

        #expect(DSSurfaceStyleResolver.fillColor(for: .primary, theme: theme) == semantic.surfacePrimary)
        #expect(DSSurfaceStyleResolver.fillColor(for: .secondary, theme: theme) == semantic.surfaceSecondary)
        #expect(DSSurfaceStyleResolver.fillColor(for: .elevated, theme: theme) == semantic.surfaceElevated)
    }

    @Test func noFillResolvesToNil() {
        #expect(DSSurfaceStyleResolver.fillColor(for: .none, theme: theme) == nil)
    }

    @Test func customFillIsPassedThrough() {
        #expect(DSSurfaceStyleResolver.fillColor(for: .color(.red), theme: theme) == .red)
    }

    // MARK: - Stroke Resolution

    @Test func semanticStrokesResolveToThemeColors() {
        #expect(DSSurfaceStyleResolver.strokeColor(for: .semantic, theme: theme) == theme.colors.semantic.stroke)
        #expect(DSSurfaceStyleResolver.strokeColor(for: .divider, theme: theme) == theme.colors.semantic.divider)
        #expect(DSSurfaceStyleResolver.strokeColor(for: .accent, theme: theme) == theme.colors.accent.strokeAccent)
        #expect(DSSurfaceStyleResolver.strokeColor(for: .color(.blue), theme: theme) == .blue)
    }

    @Test func strokeDefaultsToHairlineSemantic() {
        let stroke = DSSurfaceStroke()
        #expect(stroke.fill == .semantic)
        #expect(stroke.width == StrokeTokens.hairline)
    }

    // MARK: - Presets

    @Test func cardPresetIsOpaqueWithSmallElevationAndNoBorder() {
        let card = DSSurfaceStyle.card
        #expect(card.fill == .primary)
        #expect(card.stroke == nil)
        #expect(card.elevation == ElevationTokens.small)
        #expect(card.shape == .roundedRectangle(cornerRadius: RadiusTokens.large))
    }

    @Test func overlayPresetSitsAboveCard() {
        #expect(DSSurfaceStyle.overlay.fill == .elevated)
        #expect(DSSurfaceStyle.overlay.elevation == ElevationTokens.medium)
    }

    @Test func pillAndFloatingUseCapsules() {
        #expect(DSSurfaceStyle.pill.shape == .capsule)
        #expect(DSSurfaceStyle.floating.shape == .capsule)
    }

    @Test func outlineHasBorderButNoFillOrShadow() {
        let outline = DSSurfaceStyle.outline
        #expect(outline.fill == .none)
        #expect(outline.stroke == .hairline)
        #expect(outline.elevation == ElevationTokens.none)
    }

    @Test func plainPaintsNothing() {
        let plain = DSSurfaceStyle.plain
        #expect(plain.fill == .none)
        #expect(plain.stroke == nil)
        #expect(plain.elevation == ElevationTokens.none)
    }

    // MARK: - Shape Tokens

    @Test func shapeTokensMapToRadiusTokens() {
        #expect(DSSurfaceShape.small == .roundedRectangle(cornerRadius: RadiusTokens.small))
        #expect(DSSurfaceShape.medium == .roundedRectangle(cornerRadius: RadiusTokens.medium))
        #expect(DSSurfaceShape.large == .roundedRectangle(cornerRadius: RadiusTokens.large))
    }

    // MARK: - Builder Modifiers

    @Test func modifiersReturnCopiesWithoutMutatingTheOriginal() {
        let base = DSSurfaceStyle.card
        let changed = base
            .shape(.capsule)
            .fill(.secondary)
            .stroke(.accent)
            .elevation(ElevationTokens.none)

        #expect(changed.shape == .capsule)
        #expect(changed.fill == .secondary)
        #expect(changed.stroke == .accent)
        #expect(changed.elevation == ElevationTokens.none)

        // The preset is a value type and must be unchanged.
        #expect(base.shape == .roundedRectangle(cornerRadius: RadiusTokens.large))
        #expect(base.fill == .primary)
        #expect(base.stroke == nil)
        #expect(base.elevation == ElevationTokens.small)
    }

    @Test func strokeCanBeRemoved() {
        #expect(DSSurfaceStyle.outline.stroke(nil).stroke == nil)
    }

    // MARK: - DSCard Composition

    /// `DSCard` must keep rendering exactly what it did before it was rebuilt on
    /// `dsSurface`: same radius, same fill, same elevation, border only when outlined.
    @MainActor
    @Test func cardStylesMapToEquivalentSurfaces() {
        let cases: [DSCardStyle] = [.compact, .standard, .prominent, .outlined]

        for style in cases {
            let card = DSCard(style: style) { EmptyView() }
            let surface = card.surfaceStyle

            #expect(surface.shape == .roundedRectangle(cornerRadius: style.cornerRadius))
            #expect(surface.fill == .primary)
            #expect(surface.elevation == style.elevation)

            if style.borderWidth > 0 {
                #expect(surface.stroke == DSSurfaceStroke(fill: .semantic, width: style.borderWidth))
            } else {
                #expect(surface.stroke == nil)
            }
        }
    }

    @MainActor
    @Test func onlyTheOutlinedCardHasABorder() {
        #expect(DSCard(style: .outlined) { EmptyView() }.surfaceStyle.stroke != nil)

        for style in [DSCardStyle.compact, .standard, .prominent] {
            #expect(DSCard(style: style) { EmptyView() }.surfaceStyle.stroke == nil)
        }
    }
}
