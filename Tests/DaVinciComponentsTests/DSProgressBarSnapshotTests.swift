import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSProgressBar Snapshot Tests")
@MainActor
struct DSProgressBarSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Determinate Values

    @Test func progressZero_light() throws {
        let bar = DSProgressBar(value: 0.0)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-zero",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func progressHalf_light() throws {
        let bar = DSProgressBar(value: 0.5)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-half",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func progressFull_light() throws {
        let bar = DSProgressBar(value: 1.0)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-full",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func progressHalf_dark() throws {
        let bar = DSProgressBar(value: 0.5)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-half",
            size: CGSize(width: 300, height: 20),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Size Variants

    @Test func progressSmall_light() throws {
        let bar = DSProgressBar(value: 0.6, size: .small)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-small",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func progressMedium_light() throws {
        let bar = DSProgressBar(value: 0.6, size: .medium)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-medium",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func progressLarge_light() throws {
        let bar = DSProgressBar(value: 0.6, size: .large)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-large",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - With Label

    @Test func progressWithLabel_light() throws {
        let bar = DSProgressBar(value: 0.75, label: "Uploading…")
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-with-label",
            size: CGSize(width: 300, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Indeterminate

    @Test func progressIndeterminate_light() throws {
        let bar = DSProgressBar(isIndeterminate: true)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-indeterminate",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func progressIndeterminateWithLabel_light() throws {
        let bar = DSProgressBar(label: "Loading…", isIndeterminate: true)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-indeterminate-label",
            size: CGSize(width: 300, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }
}
