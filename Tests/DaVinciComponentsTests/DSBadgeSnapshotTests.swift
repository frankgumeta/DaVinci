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
        let badge = DSBadge("New", variant: .brand)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-brand",
            size: CGSize(width: 100, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func brandBadge_dark() throws {
        let badge = DSBadge("New", variant: .brand)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-brand",
            size: CGSize(width: 100, height: 40),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func successBadge_light() throws {
        let badge = DSBadge("Active", variant: .success)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-success",
            size: CGSize(width: 100, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func warningBadge_light() throws {
        let badge = DSBadge("Pending", variant: .warning)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-warning",
            size: CGSize(width: 120, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func errorBadge_light() throws {
        let badge = DSBadge("Error", variant: .error)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-error",
            size: CGSize(width: 100, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func neutralBadge_light() throws {
        let badge = DSBadge("Draft", variant: .neutral)
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
        let badge = DSBadge(variant: .error)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot",
            size: CGSize(width: 40, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func dotBadge_dark() throws {
        let badge = DSBadge(variant: .error)
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
        let badge = DSBadge("SM", variant: .brand, size: .small)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-small",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func mediumBadge_light() throws {
        let badge = DSBadge("MD", variant: .brand, size: .medium)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-medium",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func largeBadge_light() throws {
        let badge = DSBadge("LG", variant: .brand, size: .large)
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
        let badge = DSBadge(variant: .brand, size: .small)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot-small",
            size: CGSize(width: 30, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func largeDot_light() throws {
        let badge = DSBadge(variant: .brand, size: .large)
        try SnapshotTester.assertSnapshot(
            badge,
            named: "badge-dot-large",
            size: CGSize(width: 30, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }
}
