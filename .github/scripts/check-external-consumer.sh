#!/bin/bash

set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
consumer_dir="$(mktemp -d)"
trap 'rm -rf "$consumer_dir"' EXIT

mkdir -p "$consumer_dir/Sources/DaVinciConsumer"

cat > "$consumer_dir/Package.swift" <<EOF
// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "DaVinciConsumer",
    platforms: [.iOS(.v17)],
    dependencies: [.package(path: "$root")],
    targets: [
        .executableTarget(
            name: "DaVinciConsumer",
            dependencies: [
                .product(name: "DaVinciTokens", package: "DaVinci"),
                .product(name: "DaVinciComponents", package: "DaVinci"),
                .product(name: "DaVinciGallery", package: "DaVinci")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
EOF

cat > "$consumer_dir/Sources/DaVinciConsumer/main.swift" <<'EOF'
import SwiftUI
import DaVinciTokens
import DaVinciComponents
import DaVinciGallery

struct ConsumerRoot: View {
    @State private var theme = DSTheme.defaultTheme
    @State private var colorScheme: ColorScheme?

    var body: some View {
        VStack(spacing: SpacingTokens.space4) {
            DSButton("Continue", appearance: .primary) {}
            GalleryHomeScreen(
                currentTheme: $theme,
                colorSchemeOverride: $colorScheme
            )
        }
        .dsTheme(theme)
    }
}

@main
struct ConsumerApp: App {
    var body: some Scene {
        WindowGroup { ConsumerRoot() }
    }
}
EOF

(
    cd "$consumer_dir"
    xcodebuild build \
        -scheme DaVinciConsumer \
        -destination 'generic/platform=iOS Simulator' \
        -derivedDataPath "$consumer_dir/.build" \
        IPHONEOS_DEPLOYMENT_TARGET=17.0 \
        CODE_SIGNING_ALLOWED=NO
)

echo "External consumer passed for all public DaVinci products"
