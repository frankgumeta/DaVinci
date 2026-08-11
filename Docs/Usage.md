# Component Usage Guide

Practical patterns and best practices for using DaVinci components in real-world applications.

## Table of Contents
- [When to Use Which Component](#when-to-use-which-component)
- [SF Symbols with DSSymbol](#sf-symbols-with-dssymbol)
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
DSButton("Create Account", appearance: .primary) {
    createAccount()
}

// Icon-only action in toolbar
DSIconButton(
    systemName: "gear",
    titleForAccessibility: "Settings",
    appearance: .ghost
) {
    showSettings()
}
```

Use `.ghost` for low-emphasis actions placed directly on an existing surface,
such as dismiss, overflow, or toolbar actions. Ghost buttons keep the same
interaction and accessibility frames while removing fill and border. The
pre-1.4 `Variant` name and `variant:` initializers remain source-compatible.

**Rule of Thumb**: If the action needs a visible text label for clarity, use `DSButton`. If the icon is universally recognized (settings, close, share), use `DSIconButton`.

---

### SF Symbols with DSSymbol

DaVinci components accept SF Symbols via `DSSymbol`, a validated reference type
that guarantees the symbol renders on the current operating system.

```swift
// Construct with init?(systemName:) — nil means the symbol doesn't exist
// on this OS, so handle the fallback at the call site.
guard let gear = DSSymbol(systemName: "gear") else {
    return
}

// Pass to any component that accepts DSSymbol.
DSIconButton(symbol: gear, titleForAccessibility: "Settings", variant: .secondary) {
    showSettings()
}

// DSButtonIcon factories accept DSSymbol directly.
let plus = DSSymbol(systemName: "plus")!
DSButton("Add Item", icon: .leading(plus)) { addItem() }

// DSSegmentItem accepts a validated DSSymbol icon.
if let list = DSSymbol(systemName: "list.bullet") {
    DSSegmentItem(title: "List", icon: list)
}

// DSRemoteImage accepts an optional DSSymbol placeholder.
DSRemoteImage(url: url, width: 120, height: 120, placeholder: DSSymbol(systemName: "person"))
```

The string-based APIs from v1.2.0 remain available for backward compatibility:

```swift
DSIconButton(systemName: "gear", titleForAccessibility: "Settings") {}
DSButton("Add", icon: .leading(systemName: "plus")) {}
```

**When to use which**: Prefer `DSSymbol` in new code — it catches typos and
unavailable symbols at construction time. Use the `String` API only when
migrating existing call sites incrementally.

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

// Standard density without elevation
DSCard(style: .outlined) {
    DSText("Account summary", role: .headline)
}

// Loading state
DSSkeletonList(count: 5)
```

---

### Selection and Feedback

| Component | When to Use | Example |
|-----------|-------------|---------|
| **DSSwitch** | Independent on/off preference | Notifications, privacy settings |
| **DSSegmentedControl** | One choice from a small visible set | Day/week/month filters |
| **DSProgressBar** | Determinate or indeterminate progress | Uploads, long-running work |
| **DSBadge** | Compact status or count | New, warning, unread count |
| **DSDivider** | Semantic separation without a container | Rows and adjacent sections |

```swift
DSSwitch(isOn: $notificationsEnabled, label: "Notifications")
DSSegmentedControl(options: ["Day", "Week"], selectedIndex: $period)
DSProgressBar(value: uploadProgress, label: "Uploading")
DSBadge("New", tone: .brand, appearance: .filled)
DSBadge("Active", tone: .success, appearance: .subtle)
DSBadge("Failed", tone: .error, appearance: .outlined)
DSDivider()
```

`DSBadge.Tone` communicates status (`brand`, `success`, `warning`, `error`,
or `neutral`) while `DSBadge.Appearance` controls emphasis (`filled`, `subtle`,
or `outlined`). The pre-1.4 `variant:` initializer remains available and maps to
the corresponding tone with the filled appearance.

### Remote Media

Use `DSRemoteImage` when remote content needs validated HTTP/MIME handling,
deduplicated requests, bounded caching, and explicit loading/failure semantics.
Mark purely decorative content so it is omitted from the accessibility tree.

```swift
DSRemoteImage(
    url: avatarURL,
    width: 80,
    height: 80,
    cornerRadius: RadiusTokens.large,
    accessibilityLabel: "Profile photo"
)
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

### Reusable Text Field Configuration

Use `.filled` to preserve the original DaVinci appearance or `.outlined` for a
transparent field with a semantic border. Builder calls return copies, so a
configuration can be reused safely.

```swift
let accountField: DSTextField.Configuration = .outlined
    .trailing(.clear)
    .characterLimit(80)

if let person = DSSymbol(systemName: "person") {
    DSTextField(
        "Username",
        text: $username,
        configuration: accountField
            .leading(person)
            .message(.supporting("Use the name shown on your profile"))
    )
}
```

`DSFieldMessage` accepts either `.supporting` or `.error`, so both cannot be
displayed simultaneously. The clear action is the only trailing action in
1.3.0. A configured character limit prevents subsequent binding writes from
exceeding the maximum and truncates by complete Swift `Character` values.

```swift
DSTextField(
    "Bio",
    text: $bio,
    configuration: .outlined
        .message(.error("Bio is required"))
        .characterLimit(160)
)
```

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
    accessibilityLabel: "Product photo"
)
```

The default loading path validates HTTP status and image MIME type, rejects corrupt
or oversized payloads before success, and decodes away from the main actor. Oversized
payloads are rejected during the transfer rather than after it, so a misconfigured or
hostile server cannot buffer an unbounded response in memory. Requests for the same URL
*and loader identity* are deduplicated, and validated decoded images share a 50 MB LRU
cache. There is no automatic retry loop; changing the URL or recreating the view
starts a new attempt after a failure. Cancelling one view prevents stale UI updates
but does not cancel shared work that another view may still need; that work may
finish and populate the cache.

A `nil` URL renders the placeholder immediately and never passes through the loading
state, so a view with no image is deterministic to render and to snapshot.

The default loader isolates distinct `URLSession` instances automatically, and its
payload limit is part of the cache key. Pass a user- or tenant-specific
`cacheNamespace` if credentials can change without replacing the session. Equivalent
sessions may use the same namespace when they should intentionally share cached images.

Custom loaders are isolated by `cacheIdentity`, which defaults to the conforming type.
Override it when one loader type can return different bytes for the same URL:

```swift
struct TenantImageLoader: DSImageLoading {
    let tenant: String

    var cacheIdentity: String { "tenant-\(tenant)" }

    func loadImageData(from url: URL) async throws -> Data { /* ... */ }
}
```

If an image conveys no information, remove it from the accessibility tree:

```swift
DSRemoteImage(
    url: decorativeBackgroundURL,
    width: 300,
    height: 120,
    isDecorative: true
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
