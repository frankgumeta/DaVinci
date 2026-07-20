import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@MainActor
@Suite("Typography Accessibility Snapshot Tests")
struct DSTypographyAccessibilitySnapshotTests {
    let recordMode = isRecordingSnapshots

    @Test func textControlsAtAX3() throws {
        let view = VStack(alignment: .leading, spacing: SpacingTokens.space4) {
            DSText("Accessible controls with longer content", role: .body)
            DSButton(
                "Continue with accessible text",
                icon: .trailing(systemName: "arrow.right")
            ) {}
            DSBadge("Accessible status", variant: .success, size: .large)
            DSSegmentedControl(
                options: ["Overview", "Activity"],
                selectedIndex: .constant(0)
            )
        }
        .padding()
        .dynamicTypeSize(.accessibility3)

        try SnapshotTester.assertSnapshot(
            view,
            named: "typography-controls-ax3",
            size: CGSize(width: 375, height: 850),
            record: recordMode
        )
    }
}
