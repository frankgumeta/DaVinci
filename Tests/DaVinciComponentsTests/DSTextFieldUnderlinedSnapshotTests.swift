import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSTextField Underlined Snapshot Tests")
@MainActor
struct DSTextFieldUnderlinedSnapshotTests {

    let recordMode = isRecordingSnapshots

    @Test func underlined_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant(""),
            prompt: "you@example.com",
            configuration: .underlined
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-underlined",
            size: CGSize(width: 300, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func underlined_dark() throws {
        let field = DSTextField(
            "Email",
            text: .constant(""),
            prompt: "you@example.com",
            configuration: .underlined
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-underlined",
            size: CGSize(width: 300, height: 80),
            colorScheme: .dark,
            record: recordMode
        )
    }

    @Test func underlinedError_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant("invalid@"),
            configuration: .underlined.message(.error("Invalid email format"))
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-underlined-error",
            size: CGSize(width: 300, height: 100),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func underlinedFocused_light() throws {
        let field = DSTextField(
            "Email",
            text: .constant("user@example.com"),
            configuration: .underlined,
            visualStateOverride: .focused
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-underlined-focused",
            size: CGSize(width: 300, height: 80),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func underlinedAccessories_rtl() throws {
        let field = DSTextField(
            "بحث",
            text: .constant("دافنشي"),
            configuration: .underlined
                .leading(DSSymbol(systemName: "magnifyingglass")!)
                .trailing(.clear)
                .message(.supporting("اكتب عبارة البحث"))
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-underlined-accessories-rtl",
            size: CGSize(width: 340, height: 110),
            layoutDirection: .rightToLeft,
            record: recordMode
        )
    }

    @Test func underlinedLongError_ax3() throws {
        let field = DSTextField(
            "Email address",
            text: .constant("invalid@"),
            configuration: .underlined.message(
                .error("Enter a complete email address before continuing")
            )
        )
        try SnapshotTester.assertSnapshot(
            field,
            named: "textfield-underlined-long-error-ax3",
            size: CGSize(width: 340, height: 220),
            dynamicTypeSize: .accessibility3,
            record: recordMode
        )
    }
}
