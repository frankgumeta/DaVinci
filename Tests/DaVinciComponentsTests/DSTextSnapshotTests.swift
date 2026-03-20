import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSText Snapshot Tests")
@MainActor
struct DSTextSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Role Variants

    @Test func displayRole_light() throws {
        let text = DSText("Display", role: .display)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-display",
            size: CGSize(width: 300, height: 50),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func titleRole_light() throws {
        let text = DSText("Title", role: .title)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-title",
            size: CGSize(width: 300, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func headlineRole_light() throws {
        let text = DSText("Headline", role: .headline)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-headline",
            size: CGSize(width: 300, height: 40),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func bodyRole_light() throws {
        let text = DSText("Body text content", role: .body)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-body",
            size: CGSize(width: 300, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func calloutRole_light() throws {
        let text = DSText("Callout text", role: .callout)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-callout",
            size: CGSize(width: 300, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func captionRole_light() throws {
        let text = DSText("Caption text", role: .caption)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-caption",
            size: CGSize(width: 300, height: 25),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func overlineRole_light() throws {
        let text = DSText("OVERLINE", role: .overline)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-overline",
            size: CGSize(width: 300, height: 25),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Dark Mode

    @Test func bodyRole_dark() throws {
        let text = DSText("Body text content", role: .body)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-body",
            size: CGSize(width: 300, height: 30),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Color Override

    @Test func customColor_light() throws {
        let text = DSText("Custom Color", role: .body, color: .red)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-custom-color",
            size: CGSize(width: 300, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }
}
