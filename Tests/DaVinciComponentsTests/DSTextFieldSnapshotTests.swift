import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSTextField Snapshot Tests")
@MainActor
struct DSTextFieldSnapshotTests {

    let recordMode = isRecordingSnapshots

    // MARK: - Default State

    @Test func textField_withLabel_light() throws {
        let field = DSTextField("Email", text: .constant(""), prompt: "you@example.com")
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-with-label",
            size: CGSize(width: 300, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func textField_withLabel_dark() throws {
        let field = DSTextField("Email", text: .constant(""), prompt: "you@example.com")
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-with-label",
            size: CGSize(width: 300, height: 80),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func textField_withoutLabel_light() throws {
        let field = DSTextField("Search", text: .constant(""), prompt: "Search…", showsLabel: false)
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-without-label",
            size: CGSize(width: 300, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - With Content

    @Test func textField_withContent_light() throws {
        let field = DSTextField("Name", text: .constant("John Doe"))
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-with-content",
            size: CGSize(width: 300, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Error State

    @Test func textField_withError_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant("invalid@"),
            error: "Invalid email format"
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-error",
            size: CGSize(width: 300, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func textField_withError_dark() throws {
        let field = DSTextField(
            "Email",
            text: .constant("invalid@"),
            error: "Invalid email format"
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-error",
            size: CGSize(width: 300, height: 80),
            colorScheme: .dark,
            record: recordMode
        )
    }
}
