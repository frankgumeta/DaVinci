import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSSegmentedControl Snapshot Tests")
@MainActor
struct DSSegmentedControlSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Basic Segments

    @Test func threeSegments_light() throws {
        let control = DSSegmentedControl(
            options: ["Day", "Week", "Month"],
            selectedIndex: .constant(0)
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-three",
            size: CGSize(width: 320, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func threeSegments_dark() throws {
        let control = DSSegmentedControl(
            options: ["Day", "Week", "Month"],
            selectedIndex: .constant(0)
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-three",
            size: CGSize(width: 320, height: 50),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Selected Index

    @Test func middleSelected_light() throws {
        let control = DSSegmentedControl(
            options: ["Day", "Week", "Month"],
            selectedIndex: .constant(1)
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-middle-selected",
            size: CGSize(width: 320, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func lastSelected_light() throws {
        let control = DSSegmentedControl(
            options: ["Day", "Week", "Month"],
            selectedIndex: .constant(2)
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-last-selected",
            size: CGSize(width: 320, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - With Icons

    @Test func segmentsWithIcons_light() throws {
        let control = DSSegmentedControl(
            options: ["List", "Grid"],
            selectedIndex: .constant(0),
            icons: ["list.bullet", "square.grid.2x2"]
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-icons",
            size: CGSize(width: 280, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Two Segments

    @Test func twoSegments_light() throws {
        let control = DSSegmentedControl(
            options: ["On", "Off"],
            selectedIndex: .constant(0)
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-two",
            size: CGSize(width: 200, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Primary Init with DSSegmentItem

    @Test func primaryInitSegments_light() throws {
        let segments = [
            DSSegmentItem(title: "Photos", iconSystemName: "photo"),
            DSSegmentItem(title: "Videos", iconSystemName: "video"),
            DSSegmentItem(title: "Files")
        ]
        let control = DSSegmentedControl(
            segments: segments,
            selectedIndex: .constant(1)
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-primary-init",
            size: CGSize(width: 340, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }
}
