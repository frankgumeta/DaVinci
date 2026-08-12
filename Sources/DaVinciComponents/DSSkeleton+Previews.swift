import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSSkeletonList") {
    ScrollView {
        DSSkeletonList()
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — Dark") {
    ScrollView {
        DSSkeletonList()
            .padding()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSSkeletonList — Shimmer Off") {
    ScrollView {
        DSSkeletonList(isShimmering: false)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — No Leading") {
    ScrollView {
        DSSkeletonList(showLeading: false)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — Compact") {
    ScrollView {
        DSSkeletonList(count: 4, spacing: .compact, showDividers: false)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — Spaced") {
    ScrollView {
        DSSkeletonList(count: 4, spacing: .spacious, showDividers: true)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonBlock") {
    VStack(spacing: 12) {
        DSSkeletonBlock(height: 44)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonBlock — Dark") {
    VStack(spacing: 12) {
        DSSkeletonBlock(height: 44)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSSkeletonRow") {
    VStack(spacing: 0) {
        DSSkeletonRow()
        DSSkeletonRow(showLeading: false, showTrailing: true)
        DSSkeletonRow(showLeading: true, showTrailing: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonRow — Dark") {
    VStack(spacing: 0) {
        DSSkeletonRow()
        DSSkeletonRow(showLeading: false, showTrailing: true)
        DSSkeletonRow(showLeading: true, showTrailing: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSSkeletonCard") {
    VStack(spacing: 16) {
        DSSkeletonCard()
        DSSkeletonCard(showFooter: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonCard — Dark") {
    VStack(spacing: 16) {
        DSSkeletonCard()
        DSSkeletonCard(showFooter: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("Skeleton — Shimmer Off") {
    VStack(spacing: 16) {
        DSSkeletonRow(isShimmering: false)
        DSSkeletonCard(isShimmering: false)
    }
    .padding()
    .dsTheme(.defaultTheme)
}
