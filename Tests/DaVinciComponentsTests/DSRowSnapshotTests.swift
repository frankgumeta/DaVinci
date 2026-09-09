import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSListRow Snapshot Tests")
@MainActor
struct DSListRowSnapshotTests {

    let recordMode = isRecordingSnapshots

    private static let rowSize = CGSize(width: 320, height: 60)

    // MARK: - Presets

    private func assertTitleValue(_ colorScheme: ColorScheme) throws {
        try SnapshotTester.assertSnapshot(
            DSListRow(title: "Language", value: "English"),
            named: "listrow-title-value",
            size: Self.rowSize,
            colorScheme: colorScheme,
            record: recordMode
        )
    }

    @Test func titleValue_light() throws { try assertTitleValue(.light) }
    @Test func titleValue_dark() throws { try assertTitleValue(.dark) }

    private func assertTitleSubtitle(_ colorScheme: ColorScheme) throws {
        try SnapshotTester.assertSnapshot(
            DSListRow(title: "Appearance", subtitle: "Follows the system"),
            named: "listrow-title-subtitle",
            size: Self.rowSize,
            colorScheme: colorScheme,
            record: recordMode
        )
    }

    @Test func titleSubtitle_light() throws { try assertTitleSubtitle(.light) }
    @Test func titleSubtitle_dark() throws { try assertTitleSubtitle(.dark) }

    // MARK: - Slots

    private func assertSlots(_ colorScheme: ColorScheme) throws {
        let row = DSListRow(
            leading: { Image(systemName: "globe") },
            trailing: { DSRowAccessory(.chevron) },
            content: { DSRowLabel(title: "Region", subtitle: "Mexico") }
        )
        try SnapshotTester.assertSnapshot(
            row,
            named: "listrow-slots",
            size: Self.rowSize,
            colorScheme: colorScheme,
            record: recordMode
        )
    }

    @Test func slots_light() throws { try assertSlots(.light) }
    @Test func slots_dark() throws { try assertSlots(.dark) }

    // MARK: - Accessories

    @Test(arguments: [true, false])
    func selectionAccessory_light(_ isSelected: Bool) throws {
        try SnapshotTester.assertSnapshot(
            DSRowAccessory(.selection(isSelected: isSelected)),
            named: "rowaccessory-selection-\(isSelected)",
            size: CGSize(width: 44, height: 44),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func chevronAccessory_light() throws {
        try SnapshotTester.assertSnapshot(
            DSRowAccessory(.chevron),
            named: "rowaccessory-chevron",
            size: CGSize(width: 44, height: 44),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func chevronAccessory_dark() throws {
        try SnapshotTester.assertSnapshot(
            DSRowAccessory(.chevron),
            named: "rowaccessory-chevron",
            size: CGSize(width: 44, height: 44),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Right-to-Left

    /// The leading icon and trailing chevron must swap sides under RTL; a row that
    /// looks identical mirrored is a row that hard-codes its horizontal order.
    @Test func slots_rightToLeft_light() throws {
        let row = DSListRow(
            leading: { Image(systemName: "globe") },
            trailing: { DSRowAccessory(.chevron) },
            content: { DSRowLabel(title: "Region", subtitle: "Mexico") }
        )
        try SnapshotTester.assertSnapshot(
            row,
            named: "listrow-slots-rtl",
            size: Self.rowSize,
            colorScheme: .light,
            layoutDirection: .rightToLeft,
            record: recordMode
        )
    }

    // MARK: - Vertical Alignment

    /// A settings toggle row: 32pt icon, a title with a subtitle long enough to
    /// wrap, and a switch. Centred alignment drags the icon down to the middle of
    /// the wrapped subtitle, orphaning it from the title.
    private func toggleRow(alignment: VerticalAlignment) -> some View {
        DSListRow(
            alignment: alignment,
            leading: {
                Image(systemName: "headphones")
                    .frame(width: 32, height: 32)
            },
            // DSSwitch rather than a plain Toggle: UIKit-backed controls do not
            // rasterize under ImageRenderer, so a Toggle would snapshot as a
            // placeholder glyph and prove nothing about the alignment.
            trailing: { DSSwitch(isOn: .constant(true)) },
            content: {
                DSRowLabel(
                    title: "Spatial audio",
                    subtitle: "Requires headphones with motion sensors, and shows controls "
                        + "while an ambience is playing."
                )
            }
        )
    }

    @Test func topAlignedRow_light() throws {
        try SnapshotTester.assertSnapshot(
            toggleRow(alignment: .top),
            named: "listrow-alignment-top",
            size: CGSize(width: 320, height: 110),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func centerAlignedRow_light() throws {
        try SnapshotTester.assertSnapshot(
            toggleRow(alignment: .center),
            named: "listrow-alignment-center",
            size: CGSize(width: 320, height: 110),
            colorScheme: .light,
            record: recordMode
        )
    }

    /// The two alignments must actually differ. If they render identically the
    /// parameter is not reaching the layout.
    @Test func alignmentChangesTheLayout() throws {
        let top = try renderRow(alignment: .top)
        let centered = try renderRow(alignment: .center)
        #expect(top != centered, "alignment had no effect on the row layout")
    }

    private func renderRow(alignment: VerticalAlignment) throws -> Data {
        let renderer = ImageRenderer(
            content: toggleRow(alignment: alignment)
                .frame(width: 320, height: 110)
                .dsTheme(.defaultTheme)
        )
        renderer.scale = 2.0
        guard let image = renderer.uiImage, let data = image.pngData() else {
            throw SnapshotError.renderingFailed
        }
        return data
    }

    // MARK: - Dynamic Type

    @Test func titleSubtitle_accessibilityExtraExtraExtraLarge_light() throws {
        try SnapshotTester.assertSnapshot(
            DSListRow(title: "Appearance", subtitle: "Follows the system"),
            named: "listrow-title-subtitle-ax3",
            size: CGSize(width: 320, height: 160),
            colorScheme: .light,
            dynamicTypeSize: .accessibility3,
            record: recordMode
        )
    }
}

@Suite("DSActionRow Snapshot Tests")
@MainActor
struct DSActionRowSnapshotTests {

    let recordMode = isRecordingSnapshots

    private static let rowSize = CGSize(width: 320, height: 60)

    private func assertActionRow(
        named name: String,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        colorScheme: ColorScheme
    ) throws {
        let row = DSActionRow(isDisabled: isDisabled, isLoading: isLoading, action: {}, content: {
            DSRowLabel(title: "Open settings", subtitle: "Tappable row")
        })
        try SnapshotTester.assertSnapshot(
            row,
            named: name,
            size: Self.rowSize,
            colorScheme: colorScheme,
            record: recordMode
        )
    }

    @Test func enabled_light() throws {
        try assertActionRow(named: "actionrow-enabled", colorScheme: .light)
    }

    @Test func enabled_dark() throws {
        try assertActionRow(named: "actionrow-enabled", colorScheme: .dark)
    }

    @Test func disabled_light() throws {
        try assertActionRow(named: "actionrow-disabled", isDisabled: true, colorScheme: .light)
    }

    @Test func disabled_dark() throws {
        try assertActionRow(named: "actionrow-disabled", isDisabled: true, colorScheme: .dark)
    }

    @Test func loading_light() throws {
        try assertActionRow(named: "actionrow-loading", isLoading: true, colorScheme: .light)
    }

    @Test func loading_dark() throws {
        try assertActionRow(named: "actionrow-loading", isLoading: true, colorScheme: .dark)
    }

    // MARK: - Selectable

    @Test(arguments: [true, false])
    func selectable_light(_ isSelected: Bool) throws {
        try SnapshotTester.assertSnapshot(
            DSSelectableRow(isSelected: isSelected, action: {}, content: { DSRowLabel(title: "Midnight") }),
            named: "selectablerow-\(isSelected)",
            size: Self.rowSize,
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test(arguments: [true, false])
    func selectable_dark(_ isSelected: Bool) throws {
        try SnapshotTester.assertSnapshot(
            DSSelectableRow(isSelected: isSelected, action: {}, content: { DSRowLabel(title: "Midnight") }),
            named: "selectablerow-\(isSelected)",
            size: Self.rowSize,
            colorScheme: .dark,
            record: recordMode
        )
    }

    /// The checkmark must move to the leading edge under RTL.
    @Test func selectable_rightToLeft_light() throws {
        try SnapshotTester.assertSnapshot(
            DSSelectableRow(isSelected: true, action: {}, content: { DSRowLabel(title: "Midnight") }),
            named: "selectablerow-rtl",
            size: Self.rowSize,
            colorScheme: .light,
            layoutDirection: .rightToLeft,
            record: recordMode
        )
    }
}
