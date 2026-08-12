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
            symbol: DSSymbol(systemName: "heart.fill")!,
            titleForAccessibility: "Like",
            appearance: .primary,
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
            symbol: DSSymbol(systemName: "heart.fill")!,
            titleForAccessibility: "Like",
            appearance: .primary,
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
            symbol: DSSymbol(systemName: "heart.fill")!,
            titleForAccessibility: "Like",
            appearance: .primary,
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
            symbol: DSSymbol(systemName: "star.fill")!,
            titleForAccessibility: "Favorite",
            appearance: .primary,
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
            symbol: DSSymbol(systemName: "gearshape")!,
            titleForAccessibility: "Settings",
            appearance: .secondary,
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
            symbol: DSSymbol(systemName: "pencil")!,
            titleForAccessibility: "Edit",
            appearance: .outline,
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
            symbol: DSSymbol(systemName: "bell.fill")!,
            titleForAccessibility: "Notifications",
            appearance: .accent,
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

    @Test func ghostIconButton_light() throws {
        let button = DSIconButton(
            symbol: DSSymbol(systemName: "ellipsis")!,
            titleForAccessibility: "More",
            appearance: .ghost,
            size: .medium
        ) {}
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-ghost",
            size: CGSize(width: 100, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func ghostIconButton_dark() throws {
        let button = DSIconButton(
            symbol: DSSymbol(systemName: "ellipsis")!,
            titleForAccessibility: "More",
            appearance: .ghost,
            size: .medium
        ) {}
            .environment(\.dsTheme, DSTheme.defaultTheme.resolved(for: .dark))
        try SnapshotTester.assertSnapshot(
            button,
            named: "iconbutton-ghost",
            size: CGSize(width: 100, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - States

    @Test func disabledIconButton_light() throws {
        let button = DSIconButton(
            symbol: DSSymbol(systemName: "trash")!,
            titleForAccessibility: "Delete",
            appearance: .primary,
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
            symbol: DSSymbol(systemName: "arrow.clockwise")!,
            titleForAccessibility: "Refresh",
            appearance: .primary,
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
