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
    @State private var name = "Frank"
    @State private var outlinedText = ""

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

                GallerySection(title: "Outlined") {
                    DSTextField(
                        "Email",
                        text: $outlinedText,
                        prompt: "you@example.com",
                        configuration: .outlined
                    )
                    DSTextField(
                        "Name",
                        text: .constant("Frank"),
                        configuration: .outlined
                    )
                    DSTextField(
                        "Error",
                        text: .constant("bad@"),
                        configuration: .outlined.message(.error("Invalid email"))
                    )
                }

                GallerySection(title: "Accessories") {
                    DSTextField(
                        "Name",
                        text: $name,
                        configuration: .filled
                            .leading(DSSymbol(systemName: "person")!)
                            .trailing(.clear)
                    )
                    DSTextField(
                        "Search",
                        text: $search,
                        configuration: .outlined
                            .labelVisibility(.hidden)
                            .leading(DSSymbol(systemName: "magnifyingglass")!)
                            .trailing(.clear)
                    )
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

                GallerySection(title: "Messages") {
                    DSTextField(
                        "Email",
                        text: $email,
                        configuration: .filled
                            .message(.supporting("We will never share your email"))
                    )
                    DSTextField(
                        "Email",
                        text: .constant("invalid@"),
                        configuration: .filled
                            .message(.error("Invalid email format"))
                    )
                    DSTextField(
                        "Email",
                        text: .constant("invalid@"),
                        configuration: .outlined
                            .message(.error("Invalid email format"))
                    )
                }

                GallerySection(title: "Character Limit") {
                    DSTextField(
                        "Title",
                        text: $name,
                        configuration: .filled.characterLimit(10)
                    )
                    DSTextField(
                        "Bio",
                        text: $bio,
                        configuration: .outlined
                            .characterLimit(20)
                            .message(.supporting("Max 20 characters"))
                    )
                }

                GallerySection(title: "Disabled") {
                    DSTextField(
                        "Email",
                        text: .constant("disabled@example.com"),
                        configuration: .outlined
                            .message(.supporting("This field cannot be edited"))
                            .characterLimit(40)
                    )
                    .disabled(true)
                }

                GallerySection(title: "Right-to-Left") {
                    DSTextField(
                        "بحث",
                        text: .constant("دافنشي"),
                        configuration: .outlined
                            .leading(DSSymbol(systemName: "magnifyingglass")!)
                            .trailing(.clear)
                            .message(.supporting("اكتب عبارة البحث"))
                    )
                    .environment(\.layoutDirection, .rightToLeft)
                }

                GallerySection(title: "Accessibility Size") {
                    DSTextField(
                        "Email address",
                        text: .constant("invalid@"),
                        configuration: .outlined.message(
                            .error("Enter a complete email address before continuing")
                        )
                    )
                    .environment(\.dynamicTypeSize, .accessibility3)
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
