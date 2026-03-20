import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSDivider Snapshot Tests")
@MainActor
struct DSDividerSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Horizontal

    @Test func horizontalRegular_light() throws {
        let divider = DSDivider(orientation: .horizontal, style: .regular)
        try SnapshotTester.assertSnapshot(
            divider,
            named: "divider-horizontal-regular",
            size: CGSize(width: 300, height: 10),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func horizontalHairline_light() throws {
        let divider = DSDivider(orientation: .horizontal, style: .hairline)
        try SnapshotTester.assertSnapshot(
            divider,
            named: "divider-horizontal-hairline",
            size: CGSize(width: 300, height: 10),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func horizontalRegular_dark() throws {
        let divider = DSDivider(orientation: .horizontal, style: .regular)
        try SnapshotTester.assertSnapshot(
            divider,
            named: "divider-horizontal-regular",
            size: CGSize(width: 300, height: 10),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Vertical

    @Test func verticalRegular_light() throws {
        let divider = DSDivider(orientation: .vertical, style: .regular)
        try SnapshotTester.assertSnapshot(
            divider,
            named: "divider-vertical-regular",
            size: CGSize(width: 10, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func verticalHairline_light() throws {
        let divider = DSDivider(orientation: .vertical, style: .hairline)
        try SnapshotTester.assertSnapshot(
            divider,
            named: "divider-vertical-hairline",
            size: CGSize(width: 10, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }
}
