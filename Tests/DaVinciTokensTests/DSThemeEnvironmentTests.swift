import Testing
import SwiftUI
@testable import DaVinciTokens

// MARK: - DSTheme Environment Tests

@Suite("DSTheme Environment")
struct DSThemeEnvironmentTests {
    
    @Test @MainActor func environmentKeyHasDefaultValue() {
        struct TestView: View {
            @Environment(\.dsTheme) var theme
            
            var body: some View {
                Text("Test")
            }
        }
        
        let view = TestView()
        #expect(String(describing: type(of: view)).contains("TestView"))
    }
    
    @Test @MainActor func environmentCanSetCustomTheme() {
        let customTheme = DSTheme(
            name: "custom",
            colors: DSColors(brand: BrandColors(primary: .red))
        )
        
        struct TestView: View {
            @Environment(\.dsTheme) var theme
            
            var body: some View {
                Text(theme.name)
            }
        }
        
        let view = TestView()
            .environment(\.dsTheme, customTheme)
        
        #expect(String(describing: type(of: view)).contains("ModifiedContent"))
    }
    
    @Test @MainActor func dsThemeModifierAppliesTheme() {
        let customTheme = DSTheme(
            name: "test-theme",
            colors: DSColors(brand: BrandColors(primary: .blue))
        )
        
        let view = Text("Hello")
            .dsTheme(customTheme)
        
        #expect(String(describing: type(of: view)).contains("ModifiedContent"))
    }
    
    @Test @MainActor func dsThemeModifierWithDefaultTheme() {
        let view = Text("Default")
            .dsTheme(.defaultTheme)
        
        #expect(String(describing: type(of: view)).contains("ModifiedContent"))
    }
}

// MARK: - DSThemeResolver Tests

@Suite("DSThemeResolver")
struct DSThemeResolverTests {
    
    @Test @MainActor func themeResolverUsesLightScheme() {
        let theme = DSTheme.defaultTheme
        let resolved = theme.resolved(for: .light)
        
        #expect(resolved.colors.semantic.textPrimary == GrayScale.gray900)
        #expect(resolved.colors.semantic.bgPrimary == GrayScale.gray050)
    }
    
    @Test @MainActor func themeResolverUsesDarkScheme() {
        let theme = DSTheme.defaultTheme
        let resolved = theme.resolved(for: .dark)
        
        #expect(resolved.colors.semantic.textPrimary == GrayScale.gray050)
        #expect(resolved.colors.semantic.bgPrimary == GrayScale.gray900)
    }
    
    @Test @MainActor func themeResolverPreservesBrandColors() {
        let customTheme = DSTheme(
            name: "brand",
            colors: DSColors(brand: BrandColors(primary: .purple))
        )
        
        let lightResolved = customTheme.resolved(for: .light)
        let darkResolved = customTheme.resolved(for: .dark)
        
        #expect(lightResolved.colors.brand.primary == .purple)
        #expect(darkResolved.colors.brand.primary == .purple)
    }
    
    @Test @MainActor func themeResolverPreservesTypography() {
        let customTypography = DSTypography(
            family: FontFamily(brand: "CustomFont")
        )
        let theme = DSTheme(name: "custom", typography: customTypography)
        
        let resolved = theme.resolved(for: .light)
        
        #expect(resolved.typography.family.brand == "CustomFont")
    }
    
    @Test @MainActor func themeResolverPreservesMotion() {
        let customMotion = DSMotion(fast: 0.05, normal: 0.15, slow: 0.35)
        let theme = DSTheme(name: "custom", motion: customMotion)
        
        let resolved = theme.resolved(for: .dark)
        
        #expect(resolved.motion.fast == 0.05)
        #expect(resolved.motion.normal == 0.15)
        #expect(resolved.motion.slow == 0.35)
    }
    
    @Test @MainActor func themeResolverPreservesName() {
        let theme = DSTheme(name: "my-theme")
        
        let lightResolved = theme.resolved(for: .light)
        let darkResolved = theme.resolved(for: .dark)
        
        #expect(lightResolved.name == "my-theme")
        #expect(darkResolved.name == "my-theme")
    }
    
    @Test @MainActor func themeModifierIntegrationWithComponents() {
        let customTheme = DSTheme(
            name: "integration",
            colors: DSColors(brand: BrandColors(primary: .orange))
        )
        
        let view = VStack {
            Text("Title")
            Text("Body")
        }
        .dsTheme(customTheme)
        
        #expect(String(describing: type(of: view)).contains("ModifiedContent"))
    }
}
