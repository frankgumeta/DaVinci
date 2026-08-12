import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSBadge Snapshot Tests")
@MainActor
struct DSBadgeSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Variant Snapshots

    @Test func brandBadge_light() throws {
        let badge = DSBadge("New", tone: .brand)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-brand",
            size: CGSize(width: 100, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func brandBadge_dark() throws {
        let badge = DSBadge("New", tone: .brand)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-brand",
            size: CGSize(width: 100, height: 40),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func successBadge_light() throws {
        let badge = DSBadge("Active", tone: .success)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-success",
            size: CGSize(width: 100, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func warningBadge_light() throws {
        let badge = DSBadge("Pending", tone: .warning)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-warning",
            size: CGSize(width: 120, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func errorBadge_light() throws {
        let badge = DSBadge("Error", tone: .error)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-error",
            size: CGSize(width: 100, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func neutralBadge_light() throws {
        let badge = DSBadge("Draft", tone: .neutral)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-neutral",
            size: CGSize(width: 100, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Dot Badge

    @Test func dotBadge_light() throws {
        let badge = DSBadge(tone: .error)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot",
            size: CGSize(width: 40, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func dotBadge_dark() throws {
        let badge = DSBadge(tone: .error)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot",
            size: CGSize(width: 40, height: 40),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Size Variants

    @Test func smallBadge_light() throws {
        let badge = DSBadge("SM", tone: .brand, size: .small)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-small",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func mediumBadge_light() throws {
        let badge = DSBadge("MD", tone: .brand, size: .medium)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-medium",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func largeBadge_light() throws {
        let badge = DSBadge("LG", tone: .brand, size: .large)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-large",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Dot Size Variants

    @Test func smallDot_light() throws {
        let badge = DSBadge(tone: .brand, size: .small)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot-small",
            size: CGSize(width: 30, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func largeDot_light() throws {
        let badge = DSBadge(tone: .brand, size: .large)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot-large",
            size: CGSize(width: 30, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Appearance Matrix

    @Test func appearanceMatrix_light() throws {
        try SnapshotTester.assertSnapshot(
            DSBadgeAppearanceMatrix(theme: .defaultTheme.resolved(for: .light)),
            named: "badge-appearance-matrix",
            size: CGSize(width: 330, height: 70),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func appearanceMatrix_dark() throws {
        try SnapshotTester.assertSnapshot(
            DSBadgeAppearanceMatrix(theme: .defaultTheme.resolved(for: .dark)),
            named: "badge-appearance-matrix",
            size: CGSize(width: 330, height: 70),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func outlinedDot_light() throws {
        let badge = DSBadge(tone: .error, appearance: .outlined)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot-outlined",
            size: CGSize(width: 40, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }
}

private struct DSBadgeAppearanceMatrix: View {
    let theme: DSTheme

    var body: some View {
        HStack(spacing: SpacingTokens.space3) {
            DSBadge("Filled", tone: .brand, appearance: .filled)
            DSBadge("Subtle", tone: .success, appearance: .subtle)
            DSBadge("Outlined", tone: .error, appearance: .outlined)
        }
        .padding(SpacingTokens.space2)
        .environment(\.dsTheme, theme)
    }
}
