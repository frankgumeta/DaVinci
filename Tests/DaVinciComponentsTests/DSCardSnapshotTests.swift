import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSCard Snapshot Tests")
@MainActor
struct DSCardSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Compact Style

    @Test func compactCard_light() throws {
        let card = DSCard(style: .compact) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Compact Card").font(.headline)
                Text("Tighter padding, no shadow").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        try SnapshotTester.assertSnapshot(
            card,
            named: "card-compact",
            size: CGSize(width: 300, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func compactCard_dark() throws {
        let card = DSCard(style: .compact) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Compact Card").font(.headline)
                Text("Tighter padding, no shadow").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        try SnapshotTester.assertSnapshot(
            card,
            named: "card-compact",
            size: CGSize(width: 300, height: 100),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Standard Style

    @Test func standardCard_light() throws {
        let card = DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Standard Card").font(.headline)
                Text("Default card style with shadow").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        try SnapshotTester.assertSnapshot(
            card,
            named: "card-standard",
            size: CGSize(width: 300, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func standardCard_dark() throws {
        let card = DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Standard Card").font(.headline)
                Text("Default card style with shadow").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        try SnapshotTester.assertSnapshot(
            card,
            named: "card-standard",
            size: CGSize(width: 300, height: 100),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Prominent Style

    @Test func prominentCard_light() throws {
        let card = DSCard(style: .prominent) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Prominent Card").font(.headline)
                Text("Generous padding, medium shadow").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        try SnapshotTester.assertSnapshot(
            card,
            named: "card-prominent",
            size: CGSize(width: 300, height: 120),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func prominentCard_dark() throws {
        let card = DSCard(style: .prominent) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Prominent Card").font(.headline)
                Text("Generous padding, medium shadow").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        try SnapshotTester.assertSnapshot(
            card,
            named: "card-prominent",
            size: CGSize(width: 300, height: 120),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Complex Content

    @Test func cardWithComplexContent_light() throws {
        let card = DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Premium Feature").font(.headline)
                }
                Text("Access to advanced analytics and reporting").font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        try SnapshotTester.assertSnapshot(
            card,
            named: "card-complex",
            size: CGSize(width: 300, height: 120),
            colorScheme: .light,
            record: recordMode
        )
    }
}
