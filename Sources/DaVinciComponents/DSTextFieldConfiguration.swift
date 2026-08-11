// MARK: - Configuration Support Types

/// Whether the field label is rendered above the input.
public enum DSTextFieldLabelVisibility: Sendable {
    case visible
    case hidden
}

/// Trailing accessory action. Only ``clear`` is supported in 1.3.0.
public enum DSTextFieldTrailingAction: Sendable {
    /// Clears the text binding and retains focus.
    case clear
}

// MARK: - Configuration

extension DSTextField {

    /// Reusable, value-type configuration for ``DSTextField``.
    ///
    /// Build a configuration once and share it across multiple fields. Each
    /// builder method returns a copy with the requested change applied,
    /// leaving the original unchanged.
    ///
    /// ```swift
    /// let account: DSTextField.Configuration = .outlined
    ///     .labelVisibility(.hidden)
    ///     .leading(DSSymbol(systemName: "person")!)
    ///     .trailing(.clear)
    ///     .message(.supporting("Enter your account email"))
    /// ```
    ///
    /// `DSFieldMessage` is an enum, so ``DSFieldMessage/supporting(_:)`` and
    /// ``DSFieldMessage/error(_:)`` are mutually exclusive by construction.
    public struct Configuration: Sendable {

        public let appearance: DSTextField.Appearance
        public let labelVisibility: DSTextFieldLabelVisibility
        public let leading: DSSymbol?
        public let trailingAction: DSTextFieldTrailingAction?
        public let message: DSFieldMessage?
        public let characterLimit: Int?

        private init(
            appearance: DSTextField.Appearance,
            labelVisibility: DSTextFieldLabelVisibility,
            leading: DSSymbol? = nil,
            trailingAction: DSTextFieldTrailingAction? = nil,
            message: DSFieldMessage? = nil,
            characterLimit: Int? = nil
        ) {
            self.appearance = appearance
            self.labelVisibility = labelVisibility
            self.leading = leading
            self.trailingAction = trailingAction
            self.message = message
            self.characterLimit = characterLimit
        }

        /// Filled appearance with a visible label (default, matches v1.2.0).
        public static let filled = Configuration(appearance: .filled, labelVisibility: .visible)

        /// Outlined appearance with a visible label.
        public static let outlined = Configuration(appearance: .outlined, labelVisibility: .visible)

        /// Underlined appearance with a visible label.
        public static let underlined = Configuration(appearance: .underlined, labelVisibility: .visible)

        public func labelVisibility(_ visibility: DSTextFieldLabelVisibility) -> Configuration {
            copy(labelVisibility: visibility)
        }

        public func leading(_ symbol: DSSymbol) -> Configuration {
            copy(leading: symbol)
        }

        public func trailing(_ action: DSTextFieldTrailingAction) -> Configuration {
            copy(trailingAction: action)
        }

        public func message(_ newMessage: DSFieldMessage) -> Configuration {
            copy(message: newMessage)
        }

        /// Returns a copy with a nonnegative maximum character count.
        /// Negative values are normalized to zero.
        public func characterLimit(_ limit: Int) -> Configuration {
            copy(characterLimit: max(0, limit))
        }

        private func copy(
            labelVisibility: DSTextFieldLabelVisibility? = nil,
            leading: DSSymbol? = nil,
            trailingAction: DSTextFieldTrailingAction? = nil,
            message: DSFieldMessage? = nil,
            characterLimit: Int? = nil
        ) -> Configuration {
            Configuration(
                appearance: appearance,
                labelVisibility: labelVisibility ?? self.labelVisibility,
                leading: leading ?? self.leading,
                trailingAction: trailingAction ?? self.trailingAction,
                message: message ?? self.message,
                characterLimit: characterLimit ?? self.characterLimit
            )
        }
    }
}
