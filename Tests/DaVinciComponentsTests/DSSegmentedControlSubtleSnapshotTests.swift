import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSSegmentedControl Subtle Snapshot Tests")
@MainActor
struct DSSegmentedControlSubtleSnapshotTests {

    let recordMode = isRecordingSnapshots

    @Test func subtle_light() throws {
        let control = DSSegmentedControl(
            options: ["Day", "Week", "Month"],
            selectedIndex: .constant(1),
            appearance: .subtle
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-subtle",
            size: CGSize(width: 320, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func subtle_dark() throws {
        let control = DSSegmentedControl(
            options: ["Day", "Week", "Month"],
            selectedIndex: .constant(1),
            appearance: .subtle
        )
        .environment(\.dsTheme, DSTheme.defaultTheme.resolved(for: .dark))
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-subtle",
            size: CGSize(width: 320, height: 50),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func subtleIcons_light() throws {
        let control = DSSegmentedControl(
            options: ["List", "Grid"],
            selectedIndex: .constant(0),
            symbols: [
                DSSymbol(systemName: "list.bullet")!,
                DSSymbol(systemName: "square.grid.2x2")!
            ],
            appearance: .subtle
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-subtle-icons",
            size: CGSize(width: 280, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func subtle_rtl() throws {
        let control = DSSegmentedControl(
            options: ["اليوم", "الأسبوع", "الشهر"],
            selectedIndex: .constant(1),
            appearance: .subtle
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-subtle-rtl",
            size: CGSize(width: 340, height: 50),
            layoutDirection: .rightToLeft,
            record: recordMode
        )
    }

    @Test func subtleLongText_ax3() throws {
        let control = DSSegmentedControl(
            options: ["Recent items", "Saved for later"],
            selectedIndex: .constant(0),
            appearance: .subtle
        )
        try SnapshotTester.assertSnapshot(
            control,
            named: "segmented-subtle-long-text-ax3",
            size: CGSize(width: 340, height: 180),
            dynamicTypeSize: .accessibility3,
            record: recordMode
        )
    }
}
