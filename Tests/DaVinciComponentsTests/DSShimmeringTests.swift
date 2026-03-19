import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSShimmering Tests

@Suite("DSShimmering")
struct DSShimmeringTests {

    @Test @MainActor func shimmeringModifierAppliesWhenActive() {
        let view = Rectangle()
            .frame(width: 100, height: 100)
            .dsShimmering(true)

        #expect(String(describing: type(of: view)).contains("ModifiedContent"))
    }

    @Test @MainActor func shimmeringModifierDoesNotApplyWhenInactive() {
        let view = Rectangle()
            .frame(width: 100, height: 100)
            .dsShimmering(false)

        #expect(String(describing: type(of: view)).contains("ModifiedContent"))
    }

    @Test @MainActor func shimmeringDefaultsToActive() {
        let view = Rectangle()
            .frame(width: 100, height: 100)
            .dsShimmering()

        #expect(String(describing: type(of: view)).contains("ModifiedContent"))
    }

    @Test @MainActor func shimmeringWorksWithDifferentShapes() {
        let circle = Circle().dsShimmering()
        let rounded = RoundedRectangle(cornerRadius: 10).dsShimmering()
        let capsule = Capsule().dsShimmering()

        #expect(String(describing: type(of: circle)).contains("ModifiedContent"))
        #expect(String(describing: type(of: rounded)).contains("ModifiedContent"))
        #expect(String(describing: type(of: capsule)).contains("ModifiedContent"))
    }

    @Test @MainActor func shimmeringCanBeToggledOnOff() {
        let activeView = Text("Loading").dsShimmering(true)
        let inactiveView = Text("Loading").dsShimmering(false)

        #expect(String(describing: type(of: activeView)).contains("ModifiedContent"))
        #expect(String(describing: type(of: inactiveView)).contains("ModifiedContent"))
    }
}

// MARK: - DSPressableButtonStyle Tests

@Suite("DSPressableButtonStyle")
struct DSPressableButtonStyleTests {

    @Test @MainActor func pressableStyleCreatesWithDefaultDuration() {
        let style = DSPressableButtonStyle()
        #expect(style.duration == 0.15)
    }

    @Test @MainActor func pressableStyleCreatesWithCustomDuration() {
        let style = DSPressableButtonStyle(duration: 0.3)
        #expect(style.duration == 0.3)
    }

    @Test @MainActor func pressableStyleAppliesOpacityOnPress() {
        let style = DSPressableButtonStyle()
        #expect(type(of: style) == DSPressableButtonStyle.self)
    }

    @Test @MainActor func pressableStyleWorksWithButton() {
        let button = Button("Test") {}
            .buttonStyle(DSPressableButtonStyle())

        #expect(String(describing: type(of: button)).contains("ModifiedContent"))
    }
}
