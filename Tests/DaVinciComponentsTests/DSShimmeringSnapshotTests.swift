import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSShimmering Snapshot Tests")
@MainActor
struct DSShimmeringSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Active Shimmer

    @Test func shimmerActive_light() throws {
        let view = RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 200, height: 20)
            .dsShimmering(true)
        try SnapshotTester.assertSnapshot(
            view,
            named: "shimmer-active",
            size: CGSize(width: 250, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Inactive Shimmer

    @Test func shimmerInactive_light() throws {
        let view = RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 200, height: 20)
            .dsShimmering(false)
        try SnapshotTester.assertSnapshot(
            view,
            named: "shimmer-inactive",
            size: CGSize(width: 250, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func shimmerActive_dark() throws {
        let view = RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 200, height: 20)
            .dsShimmering(true)
        try SnapshotTester.assertSnapshot(
            view,
            named: "shimmer-active",
            size: CGSize(width: 250, height: 40),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Different Shapes

    @Test func shimmerCircle_light() throws {
        let view = Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 40, height: 40)
            .dsShimmering(true)
        try SnapshotTester.assertSnapshot(
            view,
            named: "shimmer-circle",
            size: CGSize(width: 60, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }
}
