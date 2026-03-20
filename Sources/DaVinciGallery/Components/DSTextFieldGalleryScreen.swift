import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSTextFieldGalleryScreen

struct DSTextFieldGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    @State private var email = ""
    @State private var search = ""
    @State private var password = ""
    @State private var bio = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Basic Usage") {
                    DSTextField("Email", text: $email, prompt: "you@example.com")
                    DSTextField("Search", text: $search, prompt: "Search components…")
                }

                GallerySection(title: "Pre-filled") {
                    DSTextField("Name", text: .constant("Frank Gumeta"))
                    DSTextField("Username", text: .constant("@frankgumeta"))
                    DSTextField("Website", text: .constant("https://frankgumeta.com"))
                }

                GallerySection(title: "With Prompts") {
                    DSTextField("Password", text: $password, prompt: "Enter your password")
                    DSTextField("Bio", text: $bio, prompt: "Tell us about yourself")
                }

                GallerySection(title: "Empty State") {
                    DSTextField("Label only", text: .constant(""))
                    DSTextField("Label with prompt", text: .constant(""), prompt: "Placeholder text")
                }

                GallerySection(title: "Edge Cases") {
                    DSTextField(
                        "A label that is longer than typical for a field",
                        text: $email,
                        prompt: "Placeholder"
                    )
                    DSTextField("Pre-filled long value", text: .constant(
                        "This is a very long pre-filled value that may scroll horizontally"
                    ))
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Text Field")
    }
}

// MARK: - Previews

#Preview("DSTextField — Light") {
    NavigationStack { DSTextFieldGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSTextField — Dark") {
    NavigationStack { DSTextFieldGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
