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
    private static let warmupIterations = 5
    private static let measurementIterations = 20

    private static func makeRow(_ index: Int) -> DSListRow<EmptyView, DSRowLabel, DSText> {
        DSListRow(title: "Row \(index)", value: "Value \(index)")
    }

    @Test(.timeLimit(.minutes(1)))
    func buildingTwoHundredRowsStaysWithinBaseline() {
        let measurements = Self.measure {
            for index in 0..<Self.rowCount {
                let row = Self.makeRow(index)
                // Touch the descriptor so the accessibility work is included rather
                // than optimized away with the unused value.
                _ = row.accessibilityDescriptor
            }
        }

        let p95 = Self.percentile(measurements, at: 0.95)
        print("Row construction: median=\(Self.percentile(measurements, at: 0.50)), p95=\(p95)")
        #expect(p95 < .seconds(2), "Row construction P95 baseline regressed: \(p95)")
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

        var rendered = false
        let measurements = Self.measure {
            let renderer = ImageRenderer(content: list)
            renderer.scale = 1.0
            rendered = renderer.uiImage != nil
        }

        #expect(rendered, "The list failed to rasterize")
        let p95 = Self.percentile(measurements, at: 0.95)
        print("List rendering: median=\(Self.percentile(measurements, at: 0.50)), p95=\(p95)")
        #expect(p95 < .seconds(10), "List rendering P95 baseline regressed: \(p95)")
    }

    /// Updating one accessory must not cost the whole list. The comparison is
    /// against the full build above: flipping a single row's selection should be
    /// orders of magnitude cheaper than constructing 200 rows.
    @Test(.timeLimit(.minutes(1)))
    func updatingASingleAccessoryIsCheap() {
        let measurements = Self.measure {
            for index in 0..<Self.rowCount {
                let accessory = DSRowAccessory(.selection(isSelected: index.isMultiple(of: 2)))
                withExtendedLifetime(accessory) {}
            }
        }

        let p95 = Self.percentile(measurements, at: 0.95)
        print("Accessory update: median=\(Self.percentile(measurements, at: 0.50)), p95=\(p95)")
        #expect(p95 < .seconds(1), "Accessory update P95 baseline regressed: \(p95)")
    }

    @Test(.timeLimit(.minutes(1)))
    func buildingTwoHundredActionRowsStaysWithinBaseline() {
        let measurements = Self.measure {
            for index in 0..<Self.rowCount {
                let row = DSActionRow(action: {}, content: { DSRowLabel(title: "Row \(index)") })
                _ = row.accessibilityDescriptor
            }
        }

        let p95 = Self.percentile(measurements, at: 0.95)
        print("Action row construction: median=\(Self.percentile(measurements, at: 0.50)), p95=\(p95)")
        #expect(p95 < .seconds(2), "Action row construction P95 baseline regressed: \(p95)")
    }

    private static func measure(_ operation: () -> Void) -> [Duration] {
        for _ in 0..<warmupIterations {
            operation()
        }

        let clock = ContinuousClock()
        var measurements: [Duration] = []
        measurements.reserveCapacity(measurementIterations)

        for _ in 0..<measurementIterations {
            measurements.append(clock.measure(operation))
        }
        return measurements
    }

    private static func percentile(_ values: [Duration], at percentile: Double) -> Duration {
        precondition(!values.isEmpty)
        precondition((0...1).contains(percentile))
        let sorted = values.sorted()
        let index = min(
            sorted.count - 1,
            Int((Double(sorted.count - 1) * percentile).rounded(.up))
        )
        return sorted[index]
    }
}
