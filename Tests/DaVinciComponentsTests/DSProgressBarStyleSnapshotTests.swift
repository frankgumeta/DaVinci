import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSProgressBar Style Snapshot Tests")
@MainActor
struct DSProgressBarStyleSnapshotTests {

    let recordMode = isRecordingSnapshots

    @Test func steppedPartial_light() throws {
        let bar = DSProgressBar(value: 0.625, size: .large, style: .stepped(count: 4))
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-stepped-partial",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func steppedPartial_dark() throws {
        let bar = DSProgressBar(value: 0.625, size: .large, style: .stepped(count: 4))
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-stepped-partial",
            size: CGSize(width: 300, height: 20),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func stripedDeterminate_light() throws {
        let bar = DSProgressBar(value: 0.65, size: .large, style: .striped)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-striped-determinate",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func stripedDeterminate_dark() throws {
        let bar = DSProgressBar(value: 0.65, size: .large, style: .striped)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-striped-determinate",
            size: CGSize(width: 300, height: 20),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func stripedIndeterminate_light() throws {
        let bar = DSProgressBar(size: .large, isIndeterminate: true, style: .striped)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-striped-indeterminate",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func shimmerDeterminate_light() throws {
        let bar = DSProgressBar(value: 0.65, size: .large, style: .shimmer)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-shimmer-determinate",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func shimmerDeterminate_dark() throws {
        let bar = DSProgressBar(value: 0.65, size: .large, style: .shimmer)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-shimmer-determinate",
            size: CGSize(width: 300, height: 20),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func shimmerIndeterminate_light() throws {
        let bar = DSProgressBar(size: .large, isIndeterminate: true, style: .shimmer)
        try SnapshotTester.assertSnapshot(
            bar,
            named: "progress-shimmer-indeterminate",
            size: CGSize(width: 300, height: 20),
            colorScheme: .light,
            record: recordMode
        )
    }
}
