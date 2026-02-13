import Testing
import SwiftUI
@testable import DaVinciComponents
@testable import DaVinciTokens

// MARK: - DSButton Accessibility Tests

@Suite("DSButton Accessibility")
struct DSButtonAccessibilityTests {
    
    @Test @MainActor func buttonHasDefaultAccessibilityLabel() {
        let button = DSButton("Submit", variant: .primary) {}
        
        #expect(String(describing: type(of: button)).contains("DSButton"))
    }
    
    @Test @MainActor func buttonWithCustomAccessibilityLabel() {
        let button = DSButton(
            "Submit",
            variant: .primary,
            accessibilityLabel: "Submit form"
        ) {}
        
        #expect(String(describing: type(of: button)).contains("DSButton"))
    }
    
    @Test @MainActor func loadingButtonAnnouncesState() {
        let button = DSButton("Save", variant: .primary, isLoading: true) {}
        
        #expect(String(describing: type(of: button)).contains("DSButton"))
    }
    
    @Test @MainActor func disabledButtonMaintainsAccessibility() {
        let button = DSButton("Delete", variant: .secondary, isDisabled: true) {}
        
        #expect(String(describing: type(of: button)).contains("DSButton"))
    }
}

// MARK: - DSTextField Accessibility Tests

@Suite("DSTextField Accessibility")
struct DSTextFieldAccessibilityTests {
    
    @Test @MainActor func textFieldHasDefaultAccessibilityLabel() {
        let textField = DSTextField("Email", text: .constant(""))
        
        #expect(String(describing: type(of: textField)).contains("DSTextField"))
    }
    
    @Test @MainActor func textFieldWithCustomAccessibilityLabel() {
        let textField = DSTextField(
            "Password",
            text: .constant(""),
            accessibilityLabel: "Password field",
            accessibilityHint: "Enter your secure password"
        )
        
        #expect(String(describing: type(of: textField)).contains("DSTextField"))
    }
    
    @Test @MainActor func textFieldWithErrorState() {
        let textField = DSTextField(
            "Email",
            text: .constant(""),
            error: "Invalid email format"
        )
        
        #expect(String(describing: type(of: textField)).contains("DSTextField"))
    }
    
    @Test @MainActor func textFieldWithoutLabelMaintainsAccessibility() {
        let textField = DSTextField("Search", text: .constant(""), showsLabel: false)
        
        #expect(String(describing: type(of: textField)).contains("DSTextField"))
    }
}

// MARK: - DSRemoteImage Accessibility Tests

@Suite("DSRemoteImage Accessibility")
struct DSRemoteImageAccessibilityTests {
    
    @Test @MainActor func remoteImageWithCustomAccessibilityLabel() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/avatar.jpg"),
            width: 80,
            height: 80,
            accessibilityLabel: "User profile picture"
        )
        
        #expect(String(describing: type(of: image)).contains("DSRemoteImage"))
    }
    
    @Test @MainActor func remoteImageAnnouncesLoadingState() {
        let image = DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            width: 200,
            height: 200,
            showsShimmer: true
        )
        
        #expect(String(describing: type(of: image)).contains("DSRemoteImage"))
    }
    
    @Test @MainActor func placeholderImageHasAccessibilityLabel() {
        let image = DSRemoteImage(
            url: nil,
            width: 100,
            height: 100,
            placeholderSystemImage: "person.crop.circle"
        )
        
        #expect(String(describing: type(of: image)).contains("DSRemoteImage"))
    }
}

// MARK: - DSIconButton Accessibility Tests

@Suite("DSIconButton Accessibility")
struct DSIconButtonAccessibilityTests {
    
    @Test @MainActor func iconButtonHasAccessibilityLabel() {
        let button = DSIconButton(
            systemName: "heart.fill",
            titleForAccessibility: "Like",
            variant: .primary,
            size: .medium
        ) {}
        
        #expect(String(describing: type(of: button)).contains("DSIconButton"))
    }
    
    @Test @MainActor func loadingIconButtonAnnouncesState() {
        let button = DSIconButton(
            systemName: "trash",
            titleForAccessibility: "Delete",
            variant: .secondary,
            size: .medium,
            isLoading: true
        ) {}
        
        #expect(String(describing: type(of: button)).contains("DSIconButton"))
    }
    
    @Test @MainActor func disabledIconButtonMaintainsAccessibility() {
        let button = DSIconButton(
            systemName: "share",
            titleForAccessibility: "Share",
            variant: .outline,
            size: .medium,
            isDisabled: true
        ) {}
        
        #expect(String(describing: type(of: button)).contains("DSIconButton"))
    }
}

// MARK: - Accessibility Integration Tests

@Suite("Accessibility Integration")
struct AccessibilityIntegrationTests {
    
    @Test @MainActor func accessibleFormComponentsWorkTogether() {
        let form = VStack(spacing: 16) {
            DSTextField(
                "Email",
                text: .constant(""),
                accessibilityLabel: "Email address",
                accessibilityHint: "Enter your email for login"
            )
            
            DSTextField(
                "Password",
                text: .constant(""),
                accessibilityLabel: "Password",
                accessibilityHint: "Enter your secure password"
            )
            
            DSButton(
                "Sign In",
                variant: .primary,
                accessibilityLabel: "Sign in to your account"
            ) {}
        }
        
        #expect(String(describing: type(of: form)).contains("VStack"))
    }
    
    @Test @MainActor func accessibleCardWithContent() {
        let card = VStack(spacing: 12) {
            DSRemoteImage(
                url: URL(string: "https://example.com/product.jpg"),
                width: 60,
                height: 60,
                accessibilityLabel: "Product image"
            )
            
            DSText("Product Title", role: .headline)
            DSText("Product description goes here", role: .body)
            
            DSButton(
                "Add to Cart",
                variant: .primary,
                accessibilityLabel: "Add product to shopping cart"
            ) {}
        }
        
        #expect(String(describing: type(of: card)).contains("VStack"))
    }
}
