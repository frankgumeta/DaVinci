import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSTextField") {
    @Previewable @State var text = ""
    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com")
        DSTextField("Name", text: .constant("Frank Gumeta"))
        DSTextField("Search", text: $text, prompt: "Search…", showsLabel: false)
    }
    .padding()
}

#Preview("DSTextField — Dark") {
    @Previewable @State var text = ""
    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com")
        DSTextField("Name", text: .constant("Frank Gumeta"))
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSTextField — Error") {
    @Previewable @State var text = "invalid@"
    DSTextField("Email", text: $text, error: "Invalid email format")
        .padding()
}

#Preview("DSTextField — Disabled") {
    @Previewable @State var text = "Frank"
    DSTextField("Name", text: $text)
        .disabled(true)
        .padding()
}

#Preview("DSTextField — Configuration") {
    @Previewable @State var text = ""
    let config: DSTextField.Configuration = .outlined
        .labelVisibility(.visible)
        .message(.supporting("Enter your account email"))

    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com", configuration: config)
        DSTextField("Username", text: $text, configuration: .filled.message(.error("Already taken")))
    }
    .padding()
}

#Preview("DSTextField — Accessories") {
    @Previewable @State var text = "Frank"
    let person = DSSymbol(systemName: "person")!
    VStack(spacing: 16) {
        DSTextField(
            "Name",
            text: $text,
            configuration: .filled.leading(person).trailing(.clear)
        )
        DSTextField(
            "Search",
            text: $text,
            configuration: .outlined
                .labelVisibility(.hidden)
                .leading(DSSymbol(systemName: "magnifyingglass")!)
                .trailing(.clear)
        )
    }
    .padding()
}

#Preview("DSTextField — Outlined") {
    @Previewable @State var text = ""
    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com", configuration: .outlined)
        DSTextField("Name", text: .constant("Frank"), configuration: .outlined)
        DSTextField("Error", text: .constant("bad@"), configuration: .outlined.message(.error("Invalid")))
    }
    .padding()
}

#Preview("DSTextField — Underlined") {
    @Previewable @State var text = "Frank"
    VStack(spacing: 16) {
        DSTextField("Email", text: .constant(""), prompt: "you@example.com", configuration: .underlined)
        DSTextField(
            "Name",
            text: $text,
            configuration: .underlined
                .leading(DSSymbol(systemName: "person")!)
                .trailing(.clear)
        )
        DSTextField(
            "Error",
            text: .constant("bad@"),
            configuration: .underlined.message(.error("Invalid email"))
        )
    }
    .padding()
}

#Preview("DSTextField — Messages") {
    @Previewable @State var text = "invalid@"
    VStack(spacing: 16) {
        DSTextField(
            "Email",
            text: $text,
            configuration: .filled.message(.supporting("We will never share your email"))
        )
        DSTextField(
            "Email",
            text: $text,
            configuration: .filled.message(.error("Invalid email format"))
        )
        DSTextField(
            "Email",
            text: $text,
            configuration: .outlined.message(.error("Invalid email format"))
        )
    }
    .padding()
}

#Preview("DSTextField — Character Limit") {
    @Previewable @State var text = "Hello"
    VStack(spacing: 16) {
        DSTextField("Title", text: $text, configuration: .filled.characterLimit(10))
        DSTextField(
            "Bio",
            text: $text,
            configuration: .outlined
                .characterLimit(20)
                .message(.supporting("Max 20 characters"))
        )
    }
    .padding()
}
