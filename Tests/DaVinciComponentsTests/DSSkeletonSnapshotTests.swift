import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSSkeleton Snapshot Tests")
@MainActor
struct DSSkeletonSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - DSSkeletonBlock

    @Test func skeletonBlock_light() throws {
        let block = DSSkeletonBlock(height: 20, width: 200)
        try SnapshotTester.assertSnapshot(
            block,
            named: "skeleton-block",
            size: CGSize(width: 250, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonBlockNoShimmer_light() throws {
        let block = DSSkeletonBlock(height: 20, width: 200, isShimmering: false)
        try SnapshotTester.assertSnapshot(
            block,
            named: "skeleton-block-no-shimmer",
            size: CGSize(width: 250, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonBlockCustomRadius_light() throws {
        let block = DSSkeletonBlock(
            height: 40,
            width: 40,
            cornerRadius: RadiusTokens.large,
            isShimmering: false
        )
        try SnapshotTester.assertSnapshot(
            block,
            named: "skeleton-block-rounded",
            size: CGSize(width: 60, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - DSSkeletonRow

    @Test func skeletonRow_light() throws {
        let row = DSSkeletonRow(isShimmering: false)
        try SnapshotTester.assertSnapshot(
            row,
            named: "skeleton-row",
            size: CGSize(width: 350, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonRowWithLeading_light() throws {
        let row = DSSkeletonRow(showLeading: true, isShimmering: false)
        try SnapshotTester.assertSnapshot(
            row,
            named: "skeleton-row-leading",
            size: CGSize(width: 350, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonRowWithTrailing_light() throws {
        let row = DSSkeletonRow(
            showLeading: true,
            showTrailing: true,
            isShimmering: false
        )
        try SnapshotTester.assertSnapshot(
            row,
            named: "skeleton-row-trailing",
            size: CGSize(width: 350, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonRowCustomWidths_light() throws {
        let row = DSSkeletonRow(
            isShimmering: false,
            primaryLineWidth: 100,
            secondaryLineWidth: 160
        )
        try SnapshotTester.assertSnapshot(
            row,
            named: "skeleton-row-custom-widths",
            size: CGSize(width: 350, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonRow_dark() throws {
        let row = DSSkeletonRow(isShimmering: false)
        try SnapshotTester.assertSnapshot(
            row,
            named: "skeleton-row",
            size: CGSize(width: 350, height: 60),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - DSSkeletonCard

    @Test func skeletonCard_light() throws {
        let card = DSSkeletonCard(isShimmering: false)
        try SnapshotTester.assertSnapshot(
            card,
            named: "skeleton-card",
            size: CGSize(width: 350, height: 220),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonCard_dark() throws {
        let card = DSSkeletonCard(isShimmering: false)
        try SnapshotTester.assertSnapshot(
            card,
            named: "skeleton-card",
            size: CGSize(width: 350, height: 220),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - DSSkeletonList

    @Test func skeletonListSmall_light() throws {
        let list = DSSkeletonList(count: 3, isShimmering: false)
        try SnapshotTester.assertSnapshot(
            list,
            named: "skeleton-list-3",
            size: CGSize(width: 350, height: 200),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonListNoLeading_light() throws {
        let list = DSSkeletonList(count: 3, showLeading: false, isShimmering: false)
        try SnapshotTester.assertSnapshot(
            list,
            named: "skeleton-list-no-leading",
            size: CGSize(width: 350, height: 200),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonListWithTrailing_light() throws {
        let list = DSSkeletonList(
            count: 3,
            showLeading: true,
            showTrailing: true,
            isShimmering: false
        )
        try SnapshotTester.assertSnapshot(
            list,
            named: "skeleton-list-trailing",
            size: CGSize(width: 350, height: 200),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonListNoDividers_light() throws {
        let list = DSSkeletonList(
            count: 3,
            isShimmering: false,
            showDividers: false
        )
        try SnapshotTester.assertSnapshot(
            list,
            named: "skeleton-list-no-dividers",
            size: CGSize(width: 350, height: 200),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonListSpaciousSpacing_light() throws {
        let list = DSSkeletonList(
            count: 3,
            isShimmering: false,
            spacing: .spacious,
            showDividers: false
        )
        try SnapshotTester.assertSnapshot(
            list,
            named: "skeleton-list-spacious",
            size: CGSize(width: 350, height: 220),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func skeletonList_dark() throws {
        let list = DSSkeletonList(count: 3, isShimmering: false)
        try SnapshotTester.assertSnapshot(
            list,
            named: "skeleton-list-3",
            size: CGSize(width: 350, height: 200),
            colorScheme: .dark,
            record: recordMode
        )
    }
}
