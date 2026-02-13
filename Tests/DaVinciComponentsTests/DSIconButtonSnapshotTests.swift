import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSIconButton Snapshot Tests")
@MainActor
struct DSIconButtonSnapshotTests {
    
    let recordMode = isRecordingSnapshots
    
    // MARK: - Size Variants
    
    @Test func smallIconButton_light() throws {
        let button = DSIconButton(
            systemName: "heart.fill",
            titleForAccessibility: "Like",
            variant: .primary,
            size: .small
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-small",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func mediumIconButton_light() throws {
        let button = DSIconButton(
            systemName: "heart.fill",
            titleForAccessibility: "Like",
            variant: .primary,
            size: .medium
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-medium",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func largeIconButton_light() throws {
        let button = DSIconButton(
            systemName: "heart.fill",
            titleForAccessibility: "Like",
            variant: .primary,
            size: .large
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-large",
            size: CGSize(width: 100, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    // MARK: - Variant Styles
    
    @Test func primaryIconButton_dark() throws {
        let button = DSIconButton(
            systemName: "star.fill",
            titleForAccessibility: "Favorite",
            variant: .primary,
            size: .medium
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-primary",
            size: CGSize(width: 100, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }
    
    @Test func secondaryIconButton_light() throws {
        let button = DSIconButton(
            systemName: "gearshape",
            titleForAccessibility: "Settings",
            variant: .secondary,
            size: .medium
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-secondary",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func outlineIconButton_light() throws {
        let button = DSIconButton(
            systemName: "pencil",
            titleForAccessibility: "Edit",
            variant: .outline,
            size: .medium
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-outline",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func accentIconButton_light() throws {
        let button = DSIconButton(
            systemName: "bell.fill",
            titleForAccessibility: "Notifications",
            variant: .accent,
            size: .medium
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-accent",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    // MARK: - States
    
    @Test func disabledIconButton_light() throws {
        let button = DSIconButton(
            systemName: "trash",
            titleForAccessibility: "Delete",
            variant: .primary,
            size: .medium,
            isDisabled: true
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-disabled",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
    
    @Test func loadingIconButton_light() throws {
        let button = DSIconButton(
            systemName: "arrow.clockwise",
            titleForAccessibility: "Refresh",
            variant: .primary,
            size: .medium,
            isLoading: true
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-loading",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
}
