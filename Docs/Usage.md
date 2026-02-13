# Component Usage Guide

Practical patterns and best practices for using DaVinci components in real-world applications.

## Table of Contents
- [When to Use Which Component](#when-to-use-which-component)
- [Common Patterns](#common-patterns)
- [Forms](#forms)
- [Lists and Cards](#lists-and-cards)
- [Loading States](#loading-states)
- [Error Handling](#error-handling)
- [Accessibility Patterns](#accessibility-patterns)

---

## When to Use Which Component

### Buttons

| Component | When to Use | Example |
|-----------|-------------|---------|
| **DSButton** | Primary actions with text labels | "Submit Form", "Sign In", "Add to Cart" |
| **DSIconButton** | Icon-only actions where space is limited | Toolbar buttons, floating actions, list row actions |

```swift
// Text-based primary action
DSButton("Create Account", variant: .primary) {
    createAccount()
}

// Icon-only action in toolbar
DSIconButton(
    systemName: "gear",
    titleForAccessibility: "Settings",
    variant: .secondary
) {
    showSettings()
}
```

**Rule of Thumb**: If the action needs a visible text label for clarity, use `DSButton`. If the icon is universally recognized (settings, close, share), use `DSIconButton`.

---

### Text Components

| Component | When to Use | Example |
|-----------|-------------|---------|
| **DSText** | Static text with semantic roles | Headings, body content, captions |
| **DSTextField** | Single-line text input | Email, username, search |

```swift
// Page title
DSText("Account Settings", role: .title)

// Input field
DSTextField("Email", text: $email, prompt: "you@example.com")
```

---

### Layout Components

| Component | When to Use | Example |
|-----------|-------------|---------|
| **DSCard** | Group related content with elevation | Profile cards, product cards, settings groups |
| **DSSkeleton** | Loading placeholders | Shimmer effect while data loads |

```swift
// Content grouping
DSCard(style: .standard) {
    VStack(alignment: .leading, spacing: 8) {
        DSText("Profile", role: .headline)
        DSText("Manage your account", role: .body)
    }
}

// Loading state
DSSkeletonList(count: 5)
```

---

## Common Patterns

### 1. Full-Width CTAs

```swift
VStack {
    Spacer()
    
    DSButton("Continue", variant: .primary) {
        onContinue()
    }
    .padding(.horizontal, SpacingTokens.space4)
}
```

### 2. Button Groups

```swift
HStack(spacing: SpacingTokens.space2) {
    DSButton("Cancel", variant: .outline) {
        dismiss()
    }
    
    DSButton("Save", variant: .primary) {
        save()
    }
}
```

### 3. Icon + Text Button

```swift
DSButton(
    "Download PDF",
    variant: .secondary,
    icon: .leading(systemName: "arrow.down.doc")
) {
    downloadPDF()
}
```

### 4. Card with Action

```swift
DSCard(
    style: .standard,
    accessibilityLabel: "Premium feature card",
    accessibilityTraits: .isButton
) {
    VStack(alignment: .leading, spacing: 12) {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            DSText("Premium", role: .headline)
        }
        
        DSText("Unlock advanced features", role: .body)
        
        DSButton("Upgrade Now", variant: .primary) {
            showUpgrade()
        }
    }
}
```

---

## Forms

### Basic Form

```swift
@State private var email = ""
@State private var password = ""
@State private var isLoading = false

var body: some View {
    VStack(spacing: SpacingTokens.space4) {
        DSText("Sign In", role: .title)
        
        DSTextField(
            "Email",
            text: $email,
            prompt: "you@example.com",
            accessibilityHint: "Enter your email address"
        )
        
        DSTextField(
            "Password",
            text: $password,
            prompt: "Enter password",
            accessibilityHint: "Enter your password"
        )
        
        DSButton(
            "Sign In",
            variant: .primary,
            isLoading: isLoading,
            accessibilityHint: "Sign in to your account"
        ) {
            signIn()
        }
    }
    .padding(SpacingTokens.space4)
}
```

### Form with Validation

```swift
@State private var email = ""
@State private var emailError: String?

var body: some View {
    VStack(spacing: SpacingTokens.space4) {
        DSTextField(
            "Email",
            text: $email,
            error: emailError,
            accessibilityHint: "Enter a valid email address"
        )
        .onChange(of: email) { _, newValue in
            emailError = validateEmail(newValue)
        }
        
        DSButton(
            "Submit",
            variant: .primary,
            isDisabled: emailError != nil || email.isEmpty
        ) {
            submit()
        }
    }
}

func validateEmail(_ email: String) -> String? {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return predicate.evaluate(with: email) ? nil : "Invalid email format"
}
```

### Multi-Section Form

```swift
ScrollView {
    VStack(spacing: SpacingTokens.space5) {
        // Account Section
        DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                DSText("Account", role: .headline)
                
                DSTextField("Name", text: $name)
                DSTextField("Email", text: $email)
            }
        }
        
        // Preferences Section
        DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                DSText("Preferences", role: .headline)
                
                // Toggle components would go here
                // (not yet implemented in DaVinci 1.0)
            }
        }
        
        DSButton("Save Changes", variant: .primary) {
            saveChanges()
        }
    }
    .padding(SpacingTokens.space4)
}
```

---

## Lists and Cards

### Simple List

```swift
ScrollView {
    VStack(spacing: SpacingTokens.space2) {
        ForEach(items) { item in
            DSCard(
                style: .compact,
                accessibilityLabel: item.title
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        DSText(item.title, role: .headline)
                        DSText(item.subtitle, role: .caption)
                    }
                    
                    Spacer()
                    
                    DSIconButton(
                        systemName: "chevron.right",
                        titleForAccessibility: "View details",
                        variant: .secondary,
                        size: .small
                    ) {
                        showDetails(item)
                    }
                }
            }
            .onTapGesture {
                selectItem(item)
            }
        }
    }
    .padding(SpacingTokens.space3)
}
```

### Grid Layout

```swift
LazyVGrid(
    columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ],
    spacing: SpacingTokens.space3
) {
    ForEach(products) { product in
        DSCard(
            style: .standard,
            accessibilityLabel: "\(product.name), \(product.price)"
        ) {
            VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                // Product image would go here
                
                DSText(product.name, role: .headline)
                DSText(product.price, role: .body)
                
                DSButton("Add to Cart", variant: .primary) {
                    addToCart(product)
                }
            }
        }
    }
}
.padding(SpacingTokens.space4)
```

### List with Skeleton Loading

```swift
@State private var isLoading = true
@State private var items: [Item] = []

var body: some View {
    ScrollView {
        if isLoading {
            DSSkeletonList(count: 6)
                .padding(SpacingTokens.space3)
        } else {
            VStack(spacing: SpacingTokens.space2) {
                ForEach(items) { item in
                    // Item views
                }
            }
            .padding(SpacingTokens.space3)
        }
    }
    .task {
        await loadItems()
    }
}
```

---

## Loading States

### Button Loading

```swift
@State private var isSubmitting = false

DSButton(
    "Submit",
    variant: .primary,
    isLoading: isSubmitting
) {
    Task {
        isSubmitting = true
        await submitForm()
        isSubmitting = false
    }
}
```

### Image Loading with Skeleton

```swift
DSRemoteImage(
    url: imageURL,
    width: 300,
    height: 200,
    showsShimmer: true,
    label: "Product photo"
)
```

### Full-Screen Loading

```swift
@State private var isLoading = true

var body: some View {
    Group {
        if isLoading {
            VStack(spacing: SpacingTokens.space4) {
                DSSkeletonCard()
                DSSkeletonCard()
                DSSkeletonCard()
            }
            .padding(SpacingTokens.space4)
        } else {
            ContentView()
        }
    }
    .task {
        await loadData()
    }
}
```

### Progressive Loading

```swift
ScrollView {
    LazyVStack(spacing: SpacingTokens.space3) {
        ForEach(loadedItems) { item in
            ItemCard(item: item)
        }
        
        if hasMoreItems {
            DSSkeletonRow()
                .onAppear {
                    Task { await loadMore() }
                }
        }
    }
}
```

---

## Error Handling

### Inline Field Errors

```swift
@State private var email = ""
@State private var error: String?

DSTextField(
    "Email",
    text: $email,
    error: error,
    accessibilityHint: error != nil ? "Fix the error to continue" : nil
)

if let error = error {
    DSText(
        error,
        role: .caption,
        color: theme.colors.feedback.error
    )
}
```

### Error State Cards

```swift
DSCard(style: .standard) {
    VStack(spacing: SpacingTokens.space3) {
        Image(systemName: "exclamationmark.triangle")
            .font(.largeTitle)
            .foregroundColor(theme.colors.feedback.error)
        
        DSText("Error Loading Data", role: .headline)
        DSText("Unable to fetch content", role: .body)
        
        DSButton("Retry", variant: .outline) {
            retry()
        }
    }
}
```

### Form-Level Errors

```swift
@State private var formError: String?

VStack(spacing: SpacingTokens.space4) {
    if let formError = formError {
        DSCard(style: .compact) {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(theme.colors.feedback.error)
                DSText(formError, role: .body, color: theme.colors.feedback.error)
            }
        }
    }
    
    // Form fields...
    
    DSButton("Submit", variant: .primary) {
        if validateForm() {
            submit()
        } else {
            formError = "Please fix the errors above"
        }
    }
}
```

---

## Accessibility Patterns

### Semantic Headings

```swift
VStack(alignment: .leading, spacing: SpacingTokens.space3) {
    DSText("Settings", role: .title)
    // Automatically marked as .isHeader
    
    DSText("Account", role: .headline)
    // Automatically marked as .isHeader
    
    DSText("Manage your profile information", role: .body)
    // Regular text, no special traits
}
```

### Grouping Related Content

```swift
DSCard(
    style: .standard,
    accessibilityLabel: "Payment method card",
    accessibilityHint: "Double tap to edit"
) {
    VStack(alignment: .leading, spacing: 8) {
        DSText("Credit Card", role: .headline)
        DSText("**** 1234", role: .body)
    }
}
```

### Action Hints

```swift
DSButton(
    "Delete Account",
    variant: .outline,
    accessibilityHint: "This action cannot be undone"
) {
    deleteAccount()
}

DSIconButton(
    systemName: "trash",
    titleForAccessibility: "Delete item",
    variant: .secondary,
    accessibilityHint: "Permanently remove this item"
) {
    deleteItem()
}
```

### Loading State Announcements

```swift
// DSButton automatically announces loading state
DSButton(
    "Save",
    variant: .primary,
    isLoading: isSaving
) {
    save()
}
// VoiceOver reads: "Save - Loading" when isLoading is true
```

### Skip Loading Placeholders

```swift
// Skeleton components are automatically hidden from screen readers
DSSkeletonList(count: 5)
// VoiceOver skips these entirely
```

---

## Best Practices Summary

### DO ✅

- Use semantic text roles (`.title`, `.headline`, `.body`)
- Provide accessibility labels for icon-only buttons
- Use loading states for async operations
- Validate forms with inline error messages
- Group related content in cards
- Use skeleton placeholders for loading states
- Respect token-based spacing and sizing

### DON'T ❌

- Hard-code color values (use theme colors)
- Hard-code spacing values (use `SpacingTokens`)
- Ignore disabled states for invalid forms
- Use icon buttons without accessibility labels
- Nest cards inside cards (creates visual clutter)
- Use `DSButton` for navigation (use `NavigationLink`)
- Override component styling with arbitrary modifiers

---

## Real-World Example: Profile Screen

```swift
struct ProfileScreen: View {
    @Environment(\.dsTheme) private var theme
    @State private var name = "John Doe"
    @State private var email = "john@example.com"
    @State private var isLoading = false
    @State private var saveError: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: SpacingTokens.space4) {
                // Header
                DSText("Profile", role: .title)
                
                // Profile Image
                DSRemoteImage(
                    url: profileImageURL,
                    width: 120,
                    height: 120,
                    cornerRadius: 60,
                    label: "Profile photo"
                )
                
                // Form
                DSCard(style: .standard) {
                    VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                        DSText("Account Information", role: .headline)
                        
                        DSTextField("Name", text: $name)
                        DSTextField(
                            "Email",
                            text: $email,
                            error: saveError
                        )
                    }
                }
                
                // Actions
                HStack(spacing: SpacingTokens.space2) {
                    DSButton("Cancel", variant: .outline) {
                        dismiss()
                    }
                    
                    DSButton(
                        "Save Changes",
                        variant: .primary,
                        isLoading: isLoading
                    ) {
                        Task {
                            isLoading = true
                            saveError = await saveProfile()
                            isLoading = false
                        }
                    }
                }
            }
            .padding(SpacingTokens.space4)
        }
    }
    
    func saveProfile() async -> String? {
        // Validation and save logic
        return nil // or error message
    }
}
```

---

**Next**: See [Theming Guide](Theming.md) for customization options.
