import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSRemoteImage Snapshot Tests")
@MainActor
struct DSRemoteImageSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Nil URL (Triggers failure/placeholder path)

    @Test func remoteImageNilURL_light() throws {
        let view = DSRemoteImage(
            url: nil,
            width: 100,
            height: 100,
            showsShimmer: false,
            placeholderSystemImage: "photo"
        )
        try SnapshotTester.assertSnapshot(
            view,
            named: "remote-image-nil-url",
            size: CGSize(width: 120, height: 120),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func remoteImageNilURL_dark() throws {
        let view = DSRemoteImage(
            url: nil,
            width: 100,
            height: 100,
            showsShimmer: false,
            placeholderSystemImage: "photo"
        )
        try SnapshotTester.assertSnapshot(
            view,
            named: "remote-image-nil-url",
            size: CGSize(width: 120, height: 120),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Custom Placeholder Icon

    @Test func remoteImageCustomPlaceholder_light() throws {
        let view = DSRemoteImage(
            url: nil,
            width: 80,
            height: 80,
            cornerRadius: RadiusTokens.medium,
            showsShimmer: false,
            placeholderSystemImage: "person.crop.circle"
        )
        try SnapshotTester.assertSnapshot(
            view,
            named: "remote-image-custom-placeholder",
            size: CGSize(width: 100, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Fill vs Fit Content Mode (initial loading state)

    @Test func remoteImageFillMode_light() throws {
        let view = DSRemoteImage(
            url: URL(string: "https://example.com/test.jpg"),
            width: 120,
            height: 80,
            contentMode: .fill,
            showsShimmer: false
        )
        try SnapshotTester.assertSnapshot(
            view,
            named: "remote-image-fill-loading",
            size: CGSize(width: 140, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func remoteImageFitMode_light() throws {
        let view = DSRemoteImage(
            url: URL(string: "https://example.com/test.jpg"),
            width: 120,
            height: 80,
            contentMode: .fit,
            showsShimmer: false
        )
        try SnapshotTester.assertSnapshot(
            view,
            named: "remote-image-fit-loading",
            size: CGSize(width: 140, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Different Corner Radii

    @Test func remoteImageLargeRadius_light() throws {
        let view = DSRemoteImage(
            url: nil,
            width: 80,
            height: 80,
            cornerRadius: RadiusTokens.large,
            showsShimmer: false
        )
        try SnapshotTester.assertSnapshot(
            view,
            named: "remote-image-large-radius",
            size: CGSize(width: 100, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Shimmer Enabled (loading state)

    @Test func remoteImageShimmerLoading_light() throws {
        let view = DSRemoteImage(
            url: URL(string: "https://example.com/test.jpg"),
            width: 100,
            height: 100,
            showsShimmer: true
        )
        try SnapshotTester.assertSnapshot(
            view,
            named: "remote-image-shimmer",
            size: CGSize(width: 120, height: 120),
            colorScheme: .light,
            record: recordMode
        )
    }
}
