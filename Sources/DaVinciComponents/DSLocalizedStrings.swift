import Foundation

internal enum DSLocalizedStringKey: String, CaseIterable, Sendable {
    case clearText = "accessibility.clear.label"
    case clearTextHint = "accessibility.clear.hint"
    case empty = "accessibility.empty"
    case errorFormat = "accessibility.error.format"
    case characterProgressFormat = "accessibility.character-progress.format"
    case imageFailed = "accessibility.image.failed"
    case imageFailedValue = "accessibility.image.failed-value"
    case imageLoading = "accessibility.image.loading"
    case imagePlaceholder = "accessibility.image.placeholder"
    case imageRemote = "accessibility.image.remote"
    case loading = "accessibility.loading"
    case progress = "accessibility.progress"
    case progressPercentFormat = "accessibility.progress.percent-format"
    case toggle = "accessibility.toggle"
    case toggleOff = "accessibility.toggle.off"
    case toggleOn = "accessibility.toggle.on"
}

/// Centralizes strings owned by DaVinci so accessibility output follows the
/// application language. Consumer-provided labels remain the responsibility of
/// the host application.
internal enum DSLocalizedStrings {
    static func value(
        _ key: DSLocalizedStringKey,
        localeIdentifier: String? = nil
    ) -> String {
        let bundle = localizedBundle(for: localeIdentifier)
        return NSLocalizedString(
            key.rawValue,
            tableName: nil,
            bundle: bundle,
            value: key.rawValue,
            comment: ""
        )
    }

    static func format(
        _ key: DSLocalizedStringKey,
        localeIdentifier: String? = nil,
        arguments: [CVarArg]
    ) -> String {
        let identifier = localeIdentifier ?? Locale.current.identifier
        return String(
            format: value(key, localeIdentifier: localeIdentifier),
            locale: Locale(identifier: identifier),
            arguments: arguments
        )
    }

    private static func localizedBundle(for localeIdentifier: String?) -> Bundle {
        guard let localeIdentifier else { return .module }

        let languageCode = Locale(identifier: localeIdentifier).language.languageCode?.identifier
        for localization in [localeIdentifier, languageCode].compactMap({ $0 }) {
            if let path = Bundle.module.path(forResource: localization, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                return bundle
            }
        }
        return .module
    }
}
