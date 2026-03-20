import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSSwitch Snapshot Tests")
@MainActor
struct DSSwitchSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - On / Off States

    @Test func switchOn_light() throws {
        let toggle = DSSwitch(isOn: .constant(true))
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-on",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func switchOff_light() throws {
        let toggle = DSSwitch(isOn: .constant(false))
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-off",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func switchOn_dark() throws {
        let toggle = DSSwitch(isOn: .constant(true))
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-on",
            size: CGSize(width: 80, height: 40),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func switchOff_dark() throws {
        let toggle = DSSwitch(isOn: .constant(false))
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-off",
            size: CGSize(width: 80, height: 40),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Disabled States

    @Test func switchDisabledOn_light() throws {
        let toggle = DSSwitch(isOn: .constant(true), isDisabled: true)
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-disabled-on",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func switchDisabledOff_light() throws {
        let toggle = DSSwitch(isOn: .constant(false), isDisabled: true)
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-disabled-off",
            size: CGSize(width: 80, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - With Label

    @Test func switchWithLabel_light() throws {
        let toggle = DSSwitch(isOn: .constant(true), label: "Notifications")
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-with-label",
            size: CGSize(width: 250, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func switchWithLabelOff_light() throws {
        let toggle = DSSwitch(isOn: .constant(false), label: "Dark Mode")
        try SnapshotTester.assertSnapshot(
            toggle,
            named: "switch-with-label-off",
            size: CGSize(width: 250, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }
}
