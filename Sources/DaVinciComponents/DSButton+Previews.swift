import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSButton — Appearances") {
    VStack(spacing: 12) {
        DSButton("Primary", appearance: .primary) {}
        DSButton("Secondary", appearance: .secondary) {}
        DSButton("Outline", appearance: .outline) {}
        DSButton("Ghost", appearance: .ghost) {}
    }
    .padding()
}

#Preview("DSButton — Leading Icon") {
    VStack(spacing: 12) {
        DSButton("Add Item", appearance: .primary, icon: .leading(DSSymbol(systemName: "plus")!)) {}
        DSButton("Settings", appearance: .secondary, icon: .leading(DSSymbol(systemName: "gearshape")!)) {}
        DSButton("Edit", appearance: .outline, icon: .leading(DSSymbol(systemName: "pencil")!)) {}
    }
    .padding()
}

#Preview("DSButton — Trailing Icon") {
    VStack(spacing: 12) {
        DSButton("Continue", appearance: .primary, icon: .trailing(DSSymbol(systemName: "arrow.right")!)) {}
        DSButton("Download", appearance: .secondary, icon: .trailing(DSSymbol(systemName: "arrow.down.circle")!)) {}
        DSButton("Share", appearance: .outline, icon: .trailing(DSSymbol(systemName: "square.and.arrow.up")!)) {}
    }
    .padding()
}

#Preview("DSButton — Loading") {
    VStack(spacing: 12) {
        DSButton("Primary", appearance: .primary, isLoading: true) {}
        DSButton("Secondary", appearance: .secondary, isLoading: true) {}
        DSButton("Outline", appearance: .outline, isLoading: true) {}
        DSButton("With Icon", appearance: .primary, icon: .leading(DSSymbol(systemName: "plus")!), isLoading: true) {}
    }
    .padding()
}

#Preview("DSButton — Dark") {
    VStack(spacing: 12) {
        DSButton("Primary", appearance: .primary) {}
        DSButton("Secondary", appearance: .secondary) {}
        DSButton("Outline", appearance: .outline) {}
        DSButton("Disabled", appearance: .primary, isDisabled: true) {}
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
