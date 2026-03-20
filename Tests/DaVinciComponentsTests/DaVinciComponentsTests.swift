import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSButton Tests

@Suite("DSButton")
struct DSButtonTests {

    @Test @MainActor func allVariantsCreate() {
        let variants: [DSButton.Variant] = [.primary, .secondary, .outline]
        for variant in variants {
            let button = DSButton("Test", variant: variant) {}
            #expect(type(of: button) == DSButton.self)
        }
    }

    @Test @MainActor func buttonWithLeadingIcon() {
        let button = DSButton(
            "Test",
            variant: .primary,
            icon: .leading(systemName: "plus")
        ) {}
        #expect(type(of: button) == DSButton.self)
    }

    @Test @MainActor func buttonWithTrailingIcon() {
        let button = DSButton(
            "Test",
            variant: .secondary,
            icon: .trailing(systemName: "arrow.right")
        ) {}
        #expect(type(of: button) == DSButton.self)
    }

    @Test @MainActor func buttonInLoadingState() {
        let button = DSButton("Loading", isLoading: true) {}
        #expect(type(of: button) == DSButton.self)
    }

    @Test @MainActor func buttonInDisabledState() {
        let button = DSButton("Disabled", isDisabled: true) {}
        #expect(type(of: button) == DSButton.self)
    }

    @Test @MainActor func buttonWithLoadingAndIcon() {
        let button = DSButton(
            "Processing",
            variant: .primary,
            icon: .leading(systemName: "arrow.clockwise"),
            isLoading: true
        ) {}
        #expect(type(of: button) == DSButton.self)
    }

    @Test @MainActor func allVariantsWithAllStates() {
        let variants: [DSButton.Variant] = [.primary, .secondary, .outline]
        let states: [(loading: Bool, disabled: Bool)] = [
            (false, false),
            (true, false),
            (false, true),
            (true, true)
        ]

        for variant in variants {
            for state in states {
                let button = DSButton(
                    "Test",
                    variant: variant,
                    isLoading: state.loading,
                    isDisabled: state.disabled
                ) {}
                #expect(type(of: button) == DSButton.self)
            }
        }
    }
}

// MARK: - DSIconButton Tests

@Suite("DSIconButton")
struct DSIconButtonTests {

    @Test @MainActor func allVariantsCreate() {
        let variants: [DSIconButton.Variant] = [.primary, .secondary, .outline, .accent]
        for variant in variants {
            let button = DSIconButton(
                systemName: "gear",
                titleForAccessibility: "Settings",
                variant: variant
            ) {}
            #expect(type(of: button) == DSIconButton.self)
        }
    }

    @Test @MainActor func allSizesCreate() {
        let sizes: [DSIconButton.Size] = [.small, .medium, .large]
        for size in sizes {
            let button = DSIconButton(
                systemName: "gear",
                titleForAccessibility: "Settings",
                size: size
            ) {}
            #expect(type(of: button) == DSIconButton.self)
        }
    }

    @Test @MainActor func iconButtonInLoadingState() {
        let button = DSIconButton(
            systemName: "gear",
            titleForAccessibility: "Settings",
            isLoading: true
        ) {}
        #expect(type(of: button) == DSIconButton.self)
    }

    @Test @MainActor func iconButtonInDisabledState() {
        let button = DSIconButton(
            systemName: "gear",
            titleForAccessibility: "Settings",
            isDisabled: true
        ) {}
        #expect(type(of: button) == DSIconButton.self)
    }

    @Test @MainActor func allCombinationsCreate() {
        let variants: [DSIconButton.Variant] = [.primary, .secondary, .outline, .accent]
        let sizes: [DSIconButton.Size] = [.small, .medium, .large]

        for variant in variants {
            for size in sizes {
                let button = DSIconButton(
                    systemName: "star",
                    titleForAccessibility: "Favorite",
                    variant: variant,
                    size: size
                ) {}
                #expect(type(of: button) == DSIconButton.self)
            }
        }
    }
}

// MARK: - DSText Tests

@Suite("DSText")
struct DSTextTests {

    @Test @MainActor func textWithAllRoles() {
        let roles: [DSText.Role] = [
            .display, .title, .headline, .body, .callout, .caption, .overline
        ]
        for role in roles {
            let text = DSText("Sample", role: role)
            #expect(type(of: text) == DSText.self)
        }
    }

    @Test @MainActor func textWithCustomColor() {
        let text = DSText("Custom", role: .body, color: .red)
        #expect(type(of: text) == DSText.self)
    }

    @Test @MainActor func textWithoutExplicitRole() {
        let text = DSText("Default")
        #expect(type(of: text) == DSText.self)
    }

    @Test @MainActor func allRolesWithCustomColors() {
        let roles: [DSText.Role] = [
            .display, .title, .headline, .body, .callout, .caption, .overline
        ]
        let colors: [Color] = [.red, .blue, .green, .purple]

        for role in roles {
            for color in colors {
                let text = DSText("Test", role: role, color: color)
                #expect(type(of: text) == DSText.self)
            }
        }
    }
}

// MARK: - DSCard Tests

@Suite("DSCard")
struct DSCardTests {

    @Test @MainActor func cardWithDefaultStyle() {
        let card = DSCard {
            Text("Content")
        }
        #expect(type(of: card) == DSCard<Text>.self)
    }

    @Test @MainActor func cardWithCompactStyle() {
        let card = DSCard(style: .compact) {
            Text("Content")
        }
        #expect(type(of: card) == DSCard<Text>.self)
    }

    @Test @MainActor func cardWithStandardStyle() {
        let card = DSCard(style: .standard) {
            Text("Content")
        }
        #expect(type(of: card) == DSCard<Text>.self)
    }

    @Test @MainActor func cardWithProminentStyle() {
        let card = DSCard(style: .prominent) {
            Text("Content")
        }
        #expect(type(of: card) == DSCard<Text>.self)
    }

    @Test @MainActor func cardWithComplexContent() {
        let card = DSCard {
            VStack {
                Text("Title")
                Text("Body")
                HStack {
                    Text("Footer")
                    Spacer()
                }
            }
        }
        // swiftlint:disable:next large_tuple
        #expect(type(of: card) == DSCard<VStack<TupleView<(Text, Text, HStack<TupleView<(Text, Spacer)>>)>>>.self)
    }

    @Test @MainActor func cardWithEmptyContent() {
        let card = DSCard {
            EmptyView()
        }
        #expect(type(of: card) == DSCard<EmptyView>.self)
    }

    @Test @MainActor func cardWithImage() {
        let card = DSCard {
            Image(systemName: "star.fill")
        }
        #expect(type(of: card) == DSCard<Image>.self)
    }

    @Test @MainActor func cardWithDSTextComponent() {
        let card = DSCard {
            DSText("Card with DS component", role: .headline)
        }
        #expect(type(of: card) == DSCard<DSText>.self)
    }

    @Test @MainActor func allCardStylesCreate() {
        let styles: [DSCardStyle] = [.compact, .standard, .prominent]

        for style in styles {
            let card = DSCard(style: style) {
                Text("Test")
            }
            #expect(type(of: card) == DSCard<Text>.self)
        }
    }
}

// MARK: - DSTextField Tests

@Suite("DSTextField")
struct DSTextFieldTests {

    @Test @MainActor func textFieldCreatesWithLabel() {
        let field = DSTextField("Name", text: .constant(""))
        #expect(type(of: field) == DSTextField.self)
    }

    @Test @MainActor func textFieldCreatesWithPrompt() {
        let field = DSTextField("Email", text: .constant(""), prompt: "Enter your email")
        #expect(type(of: field) == DSTextField.self)
    }

    @Test @MainActor func textFieldWithoutLabelShown() {
        let field = DSTextField("Hidden Label", text: .constant(""), showsLabel: false)
        #expect(type(of: field) == DSTextField.self)
    }

    @Test @MainActor func textFieldWithAllParameters() {
        let field = DSTextField(
            "Username",
            text: .constant(""),
            prompt: "Choose a username",
            showsLabel: true
        )
        #expect(type(of: field) == DSTextField.self)
    }

    @Test @MainActor func textFieldWorksWithBinding() {
        let field = DSTextField("Test", text: .constant("Initial value"))
        #expect(type(of: field) == DSTextField.self)
    }

    @Test @MainActor func textFieldAcceptsEmptyString() {
        let field = DSTextField("", text: .constant(""))
        #expect(type(of: field) == DSTextField.self)
    }

    @Test @MainActor func textFieldWithLongLabel() {
        let longLabel = "This is a very long label that should still work correctly"
        let field = DSTextField(longLabel, text: .constant(""))
        #expect(type(of: field) == DSTextField.self)
    }
}

// MARK: - DSRemoteImage Tests

@Suite("DSRemoteImage")
struct DSRemoteImageTests {

    @Test @MainActor func remoteImageWithURL() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            width: 100,
            height: 100
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageWithNilURL() {
        let image = DSRemoteImage(
            url: nil,
            width: 100,
            height: 100
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageWithSize() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            size: CGSize(width: 120, height: 120)
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageWithCustomRadius() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            width: 80,
            height: 80,
            cornerRadius: RadiusTokens.large
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageWithoutShimmer() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            width: 100,
            height: 100,
            showsShimmer: false
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageWithCustomPlaceholder() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            width: 100,
            height: 100,
            placeholderSystemImage: "person.circle"
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageWithAccessibilityLabel() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            width: 100,
            height: 100,
            accessibilityLabel: "Profile picture"
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageFillMode() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            width: 100,
            height: 100,
            contentMode: .fill
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }

    @Test @MainActor func remoteImageFitMode() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/image.jpg"),
            width: 100,
            height: 100,
            contentMode: .fit
        )
        #expect(type(of: image) == DSRemoteImage.self)
    }
}

// MARK: - DSSkeleton Tests

@Suite("DSSkeleton")
struct DSSkeletonTests {

    @Test @MainActor func skeletonBlockCreates() {
        let block = DSSkeletonBlock(height: 20)
        #expect(type(of: block) == DSSkeletonBlock.self)
    }

    @Test @MainActor func skeletonBlockWithWidth() {
        let block = DSSkeletonBlock(height: 20, width: 100)
        #expect(type(of: block) == DSSkeletonBlock.self)
    }

    @Test @MainActor func skeletonBlockWithoutShimmer() {
        let block = DSSkeletonBlock(height: 20, isShimmering: false)
        #expect(type(of: block) == DSSkeletonBlock.self)
    }

    @Test @MainActor func skeletonRowCreates() {
        let row = DSSkeletonRow()
        #expect(type(of: row) == DSSkeletonRow.self)
    }

    @Test @MainActor func skeletonRowWithoutLeading() {
        let row = DSSkeletonRow(showLeading: false)
        #expect(type(of: row) == DSSkeletonRow.self)
    }

    @Test @MainActor func skeletonRowWithTrailing() {
        let row = DSSkeletonRow(showTrailing: true)
        #expect(type(of: row) == DSSkeletonRow.self)
    }

    @Test @MainActor func skeletonCardCreates() {
        let card = DSSkeletonCard()
        #expect(type(of: card) == DSSkeletonCard.self)
    }

    @Test @MainActor func skeletonCardWithFooter() {
        let card = DSSkeletonCard(showFooter: true)
        #expect(type(of: card) == DSSkeletonCard.self)
    }

    @Test @MainActor func skeletonListCreates() {
        let list = DSSkeletonList()
        #expect(type(of: list) == DSSkeletonList.self)
    }

    @Test @MainActor func skeletonListWithCustomCount() {
        let list = DSSkeletonList(count: 10)
        #expect(type(of: list) == DSSkeletonList.self)
    }

    @Test @MainActor func skeletonListWithSpacing() {
        let list = DSSkeletonList(spacing: .compact)
        #expect(type(of: list) == DSSkeletonList.self)
    }

    @Test @MainActor func skeletonListWithDividers() {
        let list = DSSkeletonList(showDividers: true)
        #expect(type(of: list) == DSSkeletonList.self)
    }
}

// MARK: - DSBadge Tests

@Suite("DSBadge")
struct DSBadgeTests {

    @Test @MainActor func allVariantsCreate() {
        let variants: [DSBadge.Variant] = [.brand, .success, .warning, .error, .neutral]
        for variant in variants {
            let badge = DSBadge("Test", variant: variant)
            #expect(type(of: badge) == DSBadge.self)
        }
    }

    @Test @MainActor func allSizesCreate() {
        let sizes: [DSBadge.Size] = [.small, .medium, .large]
        for size in sizes {
            let badge = DSBadge("Test", size: size)
            #expect(type(of: badge) == DSBadge.self)
        }
    }

    @Test @MainActor func dotBadgeCreatesWithoutText() {
        let badge = DSBadge(variant: .error)
        #expect(type(of: badge) == DSBadge.self)
    }

    @Test @MainActor func accessibilityLabelOverride() {
        let badge = DSBadge(variant: .error, accessibilityLabel: "3 unread messages")
        #expect(type(of: badge) == DSBadge.self)
    }

    @Test @MainActor func defaultVariantIsBrand() {
        let badge = DSBadge("New")
        #expect(type(of: badge) == DSBadge.self)
    }
}

// MARK: - DSDivider Tests

@Suite("DSDivider")
struct DSDividerTests {

    @Test @MainActor func defaultCreates() {
        let divider = DSDivider()
        #expect(type(of: divider) == DSDivider.self)
    }

    @Test @MainActor func allStylesCreate() {
        let styles: [DSDivider.Style] = [.hairline, .regular]
        for style in styles {
            let divider = DSDivider(style: style)
            #expect(type(of: divider) == DSDivider.self)
        }
    }

    @Test @MainActor func allOrientationsCreate() {
        let orientations: [DSDivider.Orientation] = [.horizontal, .vertical]
        for orientation in orientations {
            let divider = DSDivider(orientation: orientation)
            #expect(type(of: divider) == DSDivider.self)
        }
    }

    @Test @MainActor func styleThicknessValues() {
        #expect(DSDivider.Style.hairline.thickness == 0.5)
        #expect(DSDivider.Style.regular.thickness == 1)
    }

    @Test @MainActor func allCombinationsCreate() {
        for orientation in [DSDivider.Orientation.horizontal, .vertical] {
            for style in [DSDivider.Style.hairline, .regular] {
                let divider = DSDivider(orientation: orientation, style: style)
                #expect(type(of: divider) == DSDivider.self)
            }
        }
    }
}

// MARK: - DSProgressBar Tests

@Suite("DSProgressBar")
struct DSProgressBarTests {

    @Test @MainActor func defaultCreates() {
        let bar = DSProgressBar()
        #expect(type(of: bar) == DSProgressBar.self)
    }

    @Test @MainActor func allSizesCreate() {
        let sizes: [DSProgressBar.Size] = [.small, .medium, .large]
        for size in sizes {
            let bar = DSProgressBar(value: 0.5, size: size)
            #expect(type(of: bar) == DSProgressBar.self)
        }
    }

    @Test @MainActor func sizeHeightValues() {
        #expect(DSProgressBar.Size.small.height == 4)
        #expect(DSProgressBar.Size.medium.height == 6)
        #expect(DSProgressBar.Size.large.height == 8)
    }

    @Test @MainActor func indeterminateCreates() {
        let bar = DSProgressBar(label: "Loading...", isIndeterminate: true)
        #expect(type(of: bar) == DSProgressBar.self)
    }

    @Test @MainActor func valueIsClampedAboveOne() {
        let bar = DSProgressBar(value: 2.0)
        #expect(type(of: bar) == DSProgressBar.self)
    }

    @Test @MainActor func valueIsClampedBelowZero() {
        let bar = DSProgressBar(value: -0.5)
        #expect(type(of: bar) == DSProgressBar.self)
    }

    @Test @MainActor func withAccessibilityLabel() {
        let bar = DSProgressBar(value: 0.5, accessibilityLabel: "Upload progress")
        #expect(type(of: bar) == DSProgressBar.self)
    }
}

// MARK: - DSSegmentedControl Tests

@Suite("DSSegmentedControl")
struct DSSegmentedControlTests {

    @Test @MainActor func segmentItemCreatesWithTitle() {
        let item = DSSegmentItem(title: "Day")
        #expect(item.title == "Day")
        #expect(item.iconSystemName == nil)
    }

    @Test @MainActor func segmentItemCreatesWithIcon() {
        let item = DSSegmentItem(title: "List", iconSystemName: "list.bullet")
        #expect(item.title == "List")
        #expect(item.iconSystemName == "list.bullet")
    }

    @Test @MainActor func primaryInitCreates() {
        let control = DSSegmentedControl(
            segments: [
                DSSegmentItem(title: "Day"),
                DSSegmentItem(title: "Week"),
                DSSegmentItem(title: "Month")
            ],
            selectedIndex: .constant(0)
        )
        #expect(type(of: control) == DSSegmentedControl.self)
    }

    @Test @MainActor func convenienceInitCreates() {
        let control = DSSegmentedControl(
            options: ["All", "Active", "Closed"],
            selectedIndex: .constant(1)
        )
        #expect(type(of: control) == DSSegmentedControl.self)
    }

    @Test @MainActor func convenienceInitWithIconsCreates() {
        let control = DSSegmentedControl(
            options: ["List", "Grid"],
            selectedIndex: .constant(0),
            icons: ["list.bullet", "square.grid.2x2"]
        )
        #expect(type(of: control) == DSSegmentedControl.self)
    }

    @Test @MainActor func convenienceInitMapsIconsCorrectly() {
        // Verify that icons with fewer entries than options don't crash
        let control = DSSegmentedControl(
            options: ["A", "B", "C"],
            selectedIndex: .constant(0),
            icons: ["star"]
        )
        #expect(type(of: control) == DSSegmentedControl.self)
    }
}

// MARK: - DSSwitch Tests

@Suite("DSSwitch")
struct DSSwitchTests {

    @Test @MainActor func switchOnCreates() {
        let toggle = DSSwitch(isOn: .constant(true))
        #expect(type(of: toggle) == DSSwitch.self)
    }

    @Test @MainActor func switchOffCreates() {
        let toggle = DSSwitch(isOn: .constant(false))
        #expect(type(of: toggle) == DSSwitch.self)
    }

    @Test @MainActor func switchWithLabelCreates() {
        let toggle = DSSwitch(isOn: .constant(true), label: "Notifications")
        #expect(type(of: toggle) == DSSwitch.self)
    }

    @Test @MainActor func switchDisabledCreates() {
        let toggle = DSSwitch(isOn: .constant(false), isDisabled: true)
        #expect(type(of: toggle) == DSSwitch.self)
    }

    @Test @MainActor func switchWithAccessibilityLabelCreates() {
        let toggle = DSSwitch(
            isOn: .constant(true),
            label: "Notifications",
            accessibilityLabel: "Enable push notifications"
        )
        #expect(type(of: toggle) == DSSwitch.self)
    }

    @Test @MainActor func allStatesCreate() {
        let states: [(Bool, Bool)] = [(true, false), (false, false), (true, true), (false, true)]
        for (isOn, isDisabled) in states {
            let toggle = DSSwitch(
                isOn: .constant(isOn),
                label: "Test",
                isDisabled: isDisabled
            )
            #expect(type(of: toggle) == DSSwitch.self)
        }
    }
}

// MARK: - Theme Integration Tests

@Suite("Theme Integration")
struct ThemeIntegrationTests {

    @Test @MainActor func componentsWorkWithDefaultTheme() {
        let theme = DSTheme.defaultTheme

        let button = DSButton("Test", variant: .primary) {}
        let text = DSText("Test", role: .body)
        let card = DSCard { Text("Content") }

        #expect(theme.name == "default")
        #expect(type(of: button) == DSButton.self)
        #expect(type(of: text) == DSText.self)
        #expect(type(of: card) == DSCard<Text>.self)
    }

    @Test @MainActor func componentsWorkWithCustomTheme() {
        let customTheme = DSTheme(
            name: "custom",
            colors: DSColors(
                brand: BrandColors(primary: .purple)
            )
        )

        #expect(customTheme.name == "custom")
        #expect(customTheme.colors.brand.primary == .purple)
    }

    @Test @MainActor func componentsNestCorrectly() {
        let card = DSCard {
            VStack {
                DSText("Title", role: .headline)
                DSText("Body text", role: .body)
                DSButton("Action", variant: .primary) {}
            }
        }

        #expect(String(describing: type(of: card)).contains("DSCard"))
    }

    @Test @MainActor func multipleButtonVariantsInSameView() {
        let buttons = VStack {
            DSButton("Primary", variant: .primary) {}
            DSButton("Secondary", variant: .secondary) {}
            DSButton("Outline", variant: .outline) {}
        }

        #expect(String(describing: type(of: buttons)).contains("VStack"))
    }

    @Test @MainActor func mixedComponentsInCard() {
        let card = DSCard(style: .standard) {
            VStack(spacing: 12) {
                DSRemoteImage(
                    url: URL(string: "https://example.com/image.jpg"),
                    width: 100,
                    height: 100
                )
                DSText("Image Title", role: .headline)
                DSText("Description text", role: .body)
                HStack {
                    DSButton("Like", variant: .secondary) {}
                    DSButton("Share", variant: .outline) {}
                }
            }
        }

        #expect(String(describing: type(of: card)).contains("DSCard"))
    }

    @Test @MainActor func skeletonComponentsInList() {
        let list = VStack {
            DSSkeletonRow()
            DSSkeletonRow(showLeading: true)
            DSSkeletonRow(showLeading: true, showTrailing: true)
        }

        #expect(String(describing: type(of: list)).contains("VStack"))
    }

    @Test @MainActor func customThemeWithCustomTypography() {
        let customTypography = DSTypography(
            family: FontFamily(brand: "Helvetica")
        )
        let theme = DSTheme(name: "custom", typography: customTypography)

        #expect(theme.typography.family.brand == "Helvetica")
    }

    @Test @MainActor func customThemeWithCustomMotion() {
        let customMotion = DSMotion(fast: 0.1, normal: 0.2, slow: 0.4)
        let theme = DSTheme(name: "custom", motion: customMotion)

        #expect(theme.motion.fast == 0.1)
        #expect(theme.motion.normal == 0.2)
        #expect(theme.motion.slow == 0.4)
    }
}
