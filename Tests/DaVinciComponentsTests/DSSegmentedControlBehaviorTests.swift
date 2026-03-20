import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSSegmentedControl Behavior Tests

@Suite("DSSegmentedControl Behavior")
struct DSSegmentedControlBehaviorTests {

    // MARK: - DSSegmentItem Model

    @Test func segmentItemStoresTitle() {
        let item = DSSegmentItem(title: "Day")
        #expect(item.title == "Day")
    }

    @Test func segmentItemIconIsNilByDefault() {
        let item = DSSegmentItem(title: "Day")
        #expect(item.iconSystemName == nil)
    }

    @Test func segmentItemStoresIcon() {
        let item = DSSegmentItem(title: "List", iconSystemName: "list.bullet")
        #expect(item.iconSystemName == "list.bullet")
    }

    @Test func segmentItemEmptyTitleIsValid() {
        let item = DSSegmentItem(title: "")
        #expect(item.title == "")
    }

    // MARK: - Primary Init Segments

    @Test @MainActor func primaryInitPreservesSegments() {
        let segments = [
            DSSegmentItem(title: "Day"),
            DSSegmentItem(title: "Week"),
            DSSegmentItem(title: "Month")
        ]
        let control = DSSegmentedControl(
            segments: segments,
            selectedIndex: .constant(0)
        )

        #expect(control.segments.count == 3)
        #expect(control.segments[0].title == "Day")
        #expect(control.segments[1].title == "Week")
        #expect(control.segments[2].title == "Month")
    }

    @Test @MainActor func primaryInitPreservesIcons() {
        let segments = [
            DSSegmentItem(title: "List", iconSystemName: "list.bullet"),
            DSSegmentItem(title: "Grid", iconSystemName: "square.grid.2x2"),
            DSSegmentItem(title: "Calendar")
        ]
        let control = DSSegmentedControl(
            segments: segments,
            selectedIndex: .constant(0)
        )

        #expect(control.segments[0].iconSystemName == "list.bullet")
        #expect(control.segments[1].iconSystemName == "square.grid.2x2")
        #expect(control.segments[2].iconSystemName == nil)
    }

    // MARK: - Convenience Init Mapping

    @Test @MainActor func convenienceInitMapsOptionsToSegments() {
        let control = DSSegmentedControl(
            options: ["All", "Active", "Closed"],
            selectedIndex: .constant(0)
        )

        #expect(control.segments.count == 3)
        #expect(control.segments[0].title == "All")
        #expect(control.segments[1].title == "Active")
        #expect(control.segments[2].title == "Closed")
    }

    @Test @MainActor func convenienceInitWithNoIconsLeavesIconsNil() {
        let control = DSSegmentedControl(
            options: ["A", "B"],
            selectedIndex: .constant(0)
        )

        #expect(control.segments[0].iconSystemName == nil)
        #expect(control.segments[1].iconSystemName == nil)
    }

    @Test @MainActor func convenienceInitMapsIconsByIndex() {
        let control = DSSegmentedControl(
            options: ["List", "Grid"],
            selectedIndex: .constant(0),
            icons: ["list.bullet", "square.grid.2x2"]
        )

        #expect(control.segments[0].iconSystemName == "list.bullet")
        #expect(control.segments[1].iconSystemName == "square.grid.2x2")
    }

    @Test @MainActor func convenienceInitFewerIconsThanOptions() {
        let control = DSSegmentedControl(
            options: ["A", "B", "C"],
            selectedIndex: .constant(0),
            icons: ["star"]
        )

        #expect(control.segments.count == 3)
        #expect(control.segments[0].iconSystemName == "star")
        #expect(control.segments[1].iconSystemName == nil)
        #expect(control.segments[2].iconSystemName == nil)
    }

    @Test @MainActor func convenienceInitEmptyOptionsProducesEmptySegments() {
        let control = DSSegmentedControl(
            options: [],
            selectedIndex: .constant(0)
        )
        #expect(control.segments.isEmpty)
    }

    @Test @MainActor func convenienceInitSingleOption() {
        let control = DSSegmentedControl(
            options: ["Only"],
            selectedIndex: .constant(0),
            icons: ["star.fill"]
        )

        #expect(control.segments.count == 1)
        #expect(control.segments[0].title == "Only")
        #expect(control.segments[0].iconSystemName == "star.fill")
    }

    // MARK: - Identity Stability

    @Test @MainActor func segmentOrderIsPreserved() {
        let options = ["Alpha", "Beta", "Gamma", "Delta"]
        let control = DSSegmentedControl(
            options: options,
            selectedIndex: .constant(2)
        )

        for (index, option) in options.enumerated() {
            #expect(control.segments[index].title == option)
        }
    }
}
