import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSSurface Snapshot Tests")
@MainActor
struct DSSurfaceSnapshotTests {

    let recordMode = isRecordingSnapshots

    private static let canvas = CGSize(width: 200, height: 90)

    /// A surface carries no padding of its own, so every sample composes the same
    /// padding around the same label. Any visual difference is the style's doing.
    private func sample(_ style: DSSurfaceStyle) -> some View {
        DSText("Surface", role: .labelMedium)
            .padding(SpacingTokens.space4)
            .frame(width: 160, height: 50)
            .dsSurface(style)
    }

    private func assertStyle(
        _ style: DSSurfaceStyle,
        named name: String,
        colorScheme: ColorScheme
    ) throws {
        try SnapshotTester.assertSnapshot(
            sample(style),
            named: name,
            size: Self.canvas,
            colorScheme: colorScheme,
            record: recordMode
        )
    }

    // MARK: - Presets

    @Test func card_light() throws { try assertStyle(.card, named: "surface-card", colorScheme: .light) }
    @Test func card_dark() throws { try assertStyle(.card, named: "surface-card", colorScheme: .dark) }

    @Test func overlay_light() throws { try assertStyle(.overlay, named: "surface-overlay", colorScheme: .light) }
    @Test func overlay_dark() throws { try assertStyle(.overlay, named: "surface-overlay", colorScheme: .dark) }

    @Test func pill_light() throws { try assertStyle(.pill, named: "surface-pill", colorScheme: .light) }
    @Test func pill_dark() throws { try assertStyle(.pill, named: "surface-pill", colorScheme: .dark) }

    @Test func floating_light() throws { try assertStyle(.floating, named: "surface-floating", colorScheme: .light) }
    @Test func floating_dark() throws { try assertStyle(.floating, named: "surface-floating", colorScheme: .dark) }

    @Test func outline_light() throws { try assertStyle(.outline, named: "surface-outline", colorScheme: .light) }
    @Test func outline_dark() throws { try assertStyle(.outline, named: "surface-outline", colorScheme: .dark) }

    @Test func plain_light() throws { try assertStyle(.plain, named: "surface-plain", colorScheme: .light) }
    @Test func plain_dark() throws { try assertStyle(.plain, named: "surface-plain", colorScheme: .dark) }

    // MARK: - Shape

    @Test func circleShape_light() throws {
        try SnapshotTester.assertSnapshot(
            Color.purple
                .frame(width: 56, height: 56)
                .dsSurface(DSSurfaceStyle(shape: .circle, fill: .none)),
            named: "surface-shape-circle",
            size: CGSize(width: 80, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func capsuleShape_light() throws {
        try SnapshotTester.assertSnapshot(
            Color.teal
                .frame(width: 120, height: 44)
                .dsSurface(DSSurfaceStyle(shape: .capsule, fill: .none)),
            named: "surface-shape-capsule",
            size: CGSize(width: 150, height: 70),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Stroke

    @Test func accentStroke_light() throws {
        try assertStyle(
            DSSurfaceStyle(fill: .secondary, stroke: .accent),
            named: "surface-stroke-accent",
            colorScheme: .light
        )
    }

    @Test func accentStroke_dark() throws {
        try assertStyle(
            DSSurfaceStyle(fill: .secondary, stroke: .accent),
            named: "surface-stroke-accent",
            colorScheme: .dark
        )
    }
}

@Suite("DSActivityIndicator Snapshot Tests")
@MainActor
struct DSActivityIndicatorSnapshotTests {

    let recordMode = isRecordingSnapshots

    @Test(arguments: DSActivityIndicator.Size.allCases)
    func size_light(_ size: DSActivityIndicator.Size) throws {
        let side = ceil(size.dimension) + 16
        try SnapshotTester.assertSnapshot(
            DSActivityIndicator(size: size),
            named: "activityindicator-\(size)",
            size: CGSize(width: side, height: side),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test(arguments: DSActivityIndicator.Size.allCases)
    func size_dark(_ size: DSActivityIndicator.Size) throws {
        let side = ceil(size.dimension) + 16
        try SnapshotTester.assertSnapshot(
            DSActivityIndicator(size: size),
            named: "activityindicator-\(size)",
            size: CGSize(width: side, height: side),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func tinted_light() throws {
        try SnapshotTester.assertSnapshot(
            DSActivityIndicator(size: .medium, tint: .purple),
            named: "activityindicator-tinted",
            size: CGSize(width: 40, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }
}
