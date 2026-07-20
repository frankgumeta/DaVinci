import SwiftUI
import Testing
@testable import DaVinciTokens

@MainActor
@Suite("DSTypography Rendering")
struct DSTypographyRenderingTests {
    @Test func everyDefaultRoleGrowsAtAccessibilitySizes() throws {
        let typography = DSTypography()
        let styles = [
            typography.display,
            typography.title,
            typography.headline,
            typography.body,
            typography.callout,
            typography.caption,
            typography.overline
        ]

        for style in styles {
            let standard = try renderedSize(style: style, dynamicTypeSize: .large)
            let accessibility = try renderedSize(style: style, dynamicTypeSize: .accessibility5)

            #expect(accessibility.height > standard.height)
            #expect(accessibility.width > standard.width)
        }
    }

    @Test func largerLineHeightProducesTallerMultilineText() throws {
        let compact = DSTextStyle(size: 16, lineHeight: 16, weight: .regular)
        let spacious = DSTextStyle(size: 16, lineHeight: 28, weight: .regular)

        let compactSize = try renderedSize(style: compact, text: "First line\nSecond line")
        let spaciousSize = try renderedSize(style: spacious, text: "First line\nSecond line")

        #expect(spaciousSize.height > compactSize.height)
    }

    @Test func customFamilyWeightChangesRendering() throws {
        let family = FontFamily(brand: "Helvetica")
        let regular = DSTextStyle(size: 20, lineHeight: 26, weight: .regular)
        let bold = DSTextStyle(size: 20, lineHeight: 26, weight: .bold)

        let regularImage = try renderedImage(style: regular, family: family)
        let boldImage = try renderedImage(style: bold, family: family)

        #expect(regularImage.pngData() != boldImage.pngData())
    }

    private func renderedSize(
        style: DSTextStyle,
        family: FontFamily = FontFamily(),
        text: String = "Scalable typography",
        dynamicTypeSize: DynamicTypeSize = .large
    ) throws -> CGSize {
        try renderedImage(
            style: style,
            family: family,
            text: text,
            dynamicTypeSize: dynamicTypeSize
        ).size
    }

    private func renderedImage(
        style: DSTextStyle,
        family: FontFamily = FontFamily(),
        text: String = "Custom font weight",
        dynamicTypeSize: DynamicTypeSize = .large
    ) throws -> UIImage {
        let content = Text(text)
            .dsTextStyle(style, family: family)
            .dynamicTypeSize(dynamicTypeSize)
            .fixedSize()
            .padding(4)

        let renderer = ImageRenderer(content: content)
        renderer.scale = 1
        return try #require(renderer.uiImage)
    }
}
