import SwiftUI
import DaVinciTokens

// MARK: - Previews

private let previewPlus = DSSymbol(systemName: "plus")!
private let previewGearshape = DSSymbol(systemName: "gearshape")!
private let previewPencil = DSSymbol(systemName: "pencil")!
private let previewStarFill = DSSymbol(systemName: "star.fill")!
private let previewHeartFill = DSSymbol(systemName: "heart.fill")!
private let previewTrash = DSSymbol(systemName: "trash")!

#Preview("DSIconButton — Appearances") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .primary) {}
        DSIconButton(symbol: previewGearshape, titleForAccessibility: "Settings", appearance: .secondary) {}
        DSIconButton(symbol: previewPencil, titleForAccessibility: "Edit", appearance: .outline) {}
        DSIconButton(symbol: previewStarFill, titleForAccessibility: "Accent", appearance: .accent) {}
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Ghost", appearance: .ghost) {}
    }
    .padding()
}

#Preview("DSIconButton — Sizes") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Like", appearance: .primary, size: .small) {}
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Like", appearance: .primary, size: .medium) {}
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Like", appearance: .primary, size: .large) {}
    }
    .padding()
}

#Preview("DSIconButton — States") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", appearance: .primary) {}
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", appearance: .primary, isDisabled: true) {}
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", appearance: .primary, isLoading: true) {}
    }
    .padding()
}

#Preview("DSIconButton — All Appearances + Sizes") {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .primary, size: .small) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .secondary, size: .small) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .outline, size: .small) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .accent, size: .small) {}
        }
        HStack(spacing: 12) {
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .primary, size: .large) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .secondary, size: .large) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .outline, size: .large) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .accent, size: .large) {}
        }
    }
    .padding()
}

#Preview("DSIconButton — Dark") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", appearance: .primary) {}
        DSIconButton(symbol: previewGearshape, titleForAccessibility: "Settings", appearance: .secondary) {}
        DSIconButton(symbol: previewPencil, titleForAccessibility: "Edit", appearance: .outline) {}
        DSIconButton(symbol: previewStarFill, titleForAccessibility: "Accent", appearance: .accent) {}
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", appearance: .primary, isDisabled: true) {}
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
