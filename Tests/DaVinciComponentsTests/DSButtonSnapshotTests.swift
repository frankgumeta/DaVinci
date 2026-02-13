import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSButton Snapshot Tests")
@MainActor
struct DSButtonSnapshotTests {
    
    let recordMode = isRecordingSnapshots
    
    // MARK: - Primary Variant
    
    @Test func primaryButton_light() throws {
        let button = DSButton("Submit", variant: .primary) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-primary",
            size: CGSize(width: 200, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func primaryButton_dark() throws {
        let button = DSButton("Submit", variant: .primary) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-primary",
            size: CGSize(width: 200, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }
    
    // MARK: - Secondary Variant
    
    @Test func secondaryButton_light() throws {
        let button = DSButton("Cancel", variant: .secondary) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-secondary",
            size: CGSize(width: 200, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func secondaryButton_dark() throws {
        let button = DSButton("Cancel", variant: .secondary) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-secondary",
            size: CGSize(width: 200, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }
    
    // MARK: - Outline Variant
    
    @Test func outlineButton_light() throws {
        let button = DSButton("Details", variant: .outline) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-outline",
            size: CGSize(width: 200, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func outlineButton_dark() throws {
        let button = DSButton("Details", variant: .outline) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-outline",
            size: CGSize(width: 200, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }
    
    // MARK: - Disabled State
    
    @Test func disabledButton_light() throws {
        let button = DSButton("Submit", variant: .primary, isDisabled: true) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-disabled",
            size: CGSize(width: 200, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func disabledButton_dark() throws {
        let button = DSButton("Submit", variant: .primary, isDisabled: true) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-disabled",
            size: CGSize(width: 200, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }
    
    // MARK: - Loading State
    
    @Test func loadingButton_light() throws {
        let button = DSButton("Submit", variant: .primary, isLoading: true) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-loading",
            size: CGSize(width: 200, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func loadingButton_dark() throws {
        let button = DSButton("Submit", variant: .primary, isLoading: true) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-loading",
            size: CGSize(width: 200, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }
    
    // MARK: - With Icons
    
    @Test func buttonWithLeadingIcon_light() throws {
        let button = DSButton(
            "Download",
            variant: .primary,
            icon: .leading(systemName: "arrow.down.circle")
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-icon-leading",
            size: CGSize(width: 200, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func buttonWithTrailingIcon_light() throws {
        let button = DSButton(
            "Next",
            variant: .primary,
            icon: .trailing(systemName: "arrow.right")
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "button-icon-trailing",
            size: CGSize(width: 200, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
}
