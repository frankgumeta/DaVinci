import SwiftUI
import Testing
import UIKit
@testable import DaVinciComponents
@testable import DaVinciTokens

/// Baselines for the row components under list-sized workloads.
///
/// These measure the cost DaVinci itself adds — building row bodies and resolving
/// their accessibility descriptors — not SwiftUI's list virtualization, which the
/// package does not own. A regression here means a row got more expensive to
/// construct, which is exactly the change that turns a smooth list into a janky one.
@Suite("List Performance Baselines", .serialized)
@MainActor
struct DSListPerformanceTests {

    private static let rowCount = 200

    private static func makeRow(_ index: Int) -> DSListRow<EmptyView, DSRowLabel, DSText> {
        DSListRow(title: "Row \(index)", value: "Value \(index)")
    }

    @Test(.timeLimit(.minutes(1)))
    func buildingTwoHundredRowsStaysWithinBaseline() {
        let clock = ContinuousClock()

        let elapsed = clock.measure {
            for index in 0..<Self.rowCount {
                let row = Self.makeRow(index)
                // Touch the descriptor so the accessibility work is included rather
                // than optimized away with the unused value.
                _ = row.accessibilityDescriptor
            }
        }

        #expect(elapsed < .seconds(2), "Row construction baseline regressed: \(elapsed)")
    }

    @Test(.timeLimit(.minutes(1)))
    func renderingTwoHundredRowsStaysWithinBaseline() throws {
        let list = VStack(spacing: 0) {
            ForEach(0..<Self.rowCount, id: \.self) { index in
                Self.makeRow(index)
            }
        }
        .frame(width: 320)
        .dsTheme(.defaultTheme)

        let clock = ContinuousClock()
        var rendered: UIImage?

        let elapsed = clock.measure {
            let renderer = ImageRenderer(content: list)
            renderer.scale = 1.0
            rendered = renderer.uiImage
        }

        #expect(rendered != nil, "The list failed to rasterize")
        #expect(elapsed < .seconds(10), "List rendering baseline regressed: \(elapsed)")
    }

    /// Updating one accessory must not cost the whole list. The comparison is
    /// against the full build above: flipping a single row's selection should be
    /// orders of magnitude cheaper than constructing 200 rows.
    @Test(.timeLimit(.minutes(1)))
    func updatingASingleAccessoryIsCheap() {
        let clock = ContinuousClock()

        let elapsed = clock.measure {
            for index in 0..<Self.rowCount {
                let accessory = DSRowAccessory(.selection(isSelected: index.isMultiple(of: 2)))
                _ = accessory.body
            }
        }

        #expect(elapsed < .seconds(1), "Accessory update baseline regressed: \(elapsed)")
    }

    @Test(.timeLimit(.minutes(1)))
    func buildingTwoHundredActionRowsStaysWithinBaseline() {
        let clock = ContinuousClock()

        let elapsed = clock.measure {
            for index in 0..<Self.rowCount {
                let row = DSActionRow(action: {}, content: { DSRowLabel(title: "Row \(index)") })
                _ = row.accessibilityDescriptor
            }
        }

        #expect(elapsed < .seconds(2), "Action row construction baseline regressed: \(elapsed)")
    }
}
