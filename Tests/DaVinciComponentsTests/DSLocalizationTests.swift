import Testing
@testable import DaVinciComponents

@Suite("Component Localization")
struct DSLocalizationTests {
    @Test func englishResourcesResolveAllOwnedStrings() {
        for key in DSLocalizedStringKey.allCases {
            #expect(
                DSLocalizedStrings.value(key, localeIdentifier: "en") != key.rawValue,
                "Missing English localization for \(key.rawValue)"
            )
        }
    }

    @Test func spanishResourcesResolveAllOwnedStrings() {
        for key in DSLocalizedStringKey.allCases {
            #expect(
                DSLocalizedStrings.value(key, localeIdentifier: "es") != key.rawValue,
                "Missing Spanish localization for \(key.rawValue)"
            )
        }
    }

    @Test func spanishFormattingUsesLocalizedTemplates() {
        let progress = DSLocalizedStrings.format(
            .characterProgressFormat,
            localeIdentifier: "es",
            arguments: [3, 10]
        )
        let error = DSLocalizedStrings.format(
            .errorFormat,
            localeIdentifier: "es",
            arguments: ["Correo inválido"]
        )

        #expect(progress == "3 de 10 caracteres")
        #expect(error == "Error: Correo inválido")
    }
}
