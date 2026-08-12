import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSCard — Styles") {
    VStack(spacing: 16) {
        DSCard(style: .compact) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Compact").font(.headline)
                Text("Tighter padding, no shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Standard").font(.headline)
                Text("Default card style.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .prominent) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Prominent").font(.headline)
                Text("Generous padding, medium shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .outlined) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Outlined").font(.headline)
                Text("Standard padding, semantic border.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    .padding()
}

#Preview("DSCard — Dark") {
    VStack(spacing: 16) {
        DSCard(style: .compact) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Compact").font(.headline)
                Text("Tighter padding, no shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Standard").font(.headline)
                Text("Default card style.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .prominent) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Prominent").font(.headline)
                Text("Generous padding, medium shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .outlined) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Outlined").font(.headline)
                Text("Standard padding, semantic border.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSCard — Accessibility") {
    VStack(spacing: 16) {
        DSCard(
            style: .standard,
            accessibilityLabel: "Product card",
            accessibilityHint: "Double tap to view product details"
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Premium Headphones").font(.headline)
                Text("$299.99").font(.body).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        DSCard(
            style: .standard,
            accessibilityLabel: "Settings card",
            accessibilityTraits: .isButton
        ) {
            HStack {
                Image(systemName: "gear")
                Text("Account Settings").font(.body)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
        }
    }
    .padding()
}
