import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSTextField Snapshot Tests")
@MainActor
struct DSTextFieldSnapshotTests {

    let recordMode = true // isRecordingSnapshots

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
            size: CGSize(width: 300, height: 100),
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
            size: CGSize(width: 300, height: 100),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Outlined

    @Test func textField_outlined_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant(""),
            prompt: "you@example.com",
            configuration: .outlined
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-outlined",
            size: CGSize(width: 300, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func textField_outlined_dark() throws {
        let field = DSTextField(
            "Email",
            text: .constant(""),
            prompt: "you@example.com",
            configuration: .outlined
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-outlined",
            size: CGSize(width: 300, height: 80),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Accessories

    @Test func textField_withLeadingAndClear_light() throws {
        let field = DSTextField(
            "Name",
            text: .constant("Frank"),
            configuration: .filled
                .leading(DSSymbol(systemName: "person")!)
                .trailing(.clear)
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-accessories",
            size: CGSize(width: 300, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func textField_outlinedWithAccessories_light() throws {
        let field = DSTextField(
            "Search",
            text: .constant("query"),
            configuration: .outlined
                .labelVisibility(.hidden)
                .leading(DSSymbol(systemName: "magnifyingglass")!)
                .trailing(.clear)
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-outlined-accessories",
            size: CGSize(width: 300, height: 60),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Messages

    @Test func textField_supportingMessage_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant("user@test.com"),
            configuration: .filled
                .message(.supporting("We will never share your email"))
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-supporting-message",
            size: CGSize(width: 300, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func textField_errorMessage_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant("invalid@"),
            configuration: .filled
                .message(.error("Invalid email format"))
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-error-message",
            size: CGSize(width: 300, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func textField_errorMessageOutlined_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant("invalid@"),
            configuration: .outlined
                .message(.error("Invalid email format"))
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-error-message-outlined",
            size: CGSize(width: 300, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Character Limit

    @Test func textField_characterLimit_light() throws {
        let field = DSTextField(
            "Title",
            text: .constant("Hello"),
            configuration: .filled.characterLimit(10)
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-character-limit",
            size: CGSize(width: 300, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func textField_characterLimitOutlined_light() throws {
        let field = DSTextField(
            "Bio",
            text: .constant("Hello world"),
            configuration: .outlined
                .characterLimit(20)
                .message(.supporting("Max 20 characters"))
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-character-limit-outlined",
            size: CGSize(width: 300, height: 120),
            colorScheme: .light,
            record: recordMode
        )
    }
}
