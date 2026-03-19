// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "DaVinci",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "DaVinciTokens",
            targets: ["DaVinciTokens"]
        ),
        .library(
            name: "DaVinciComponents",
            targets: ["DaVinciComponents"]
        ),
        .library(
            name: "DaVinciGallery",
            targets: ["DaVinciGallery"]
        )
    ],
    targets: [
        // MARK: - Tokens
        .target(
            name: "DaVinciTokens"
        ),

        // MARK: - Components
        .target(
            name: "DaVinciComponents",
            dependencies: ["DaVinciTokens"]
        ),

        // MARK: - Gallery (library — previews work here)
        .target(
            name: "DaVinciGallery",
            dependencies: ["DaVinciTokens", "DaVinciComponents"]
        ),

        // MARK: - Demo (executable — thin entry point)
        .executableTarget(
            name: "DaVinciDemo",
            dependencies: ["DaVinciTokens", "DaVinciGallery"]
        ),

        // MARK: - Tests
        .testTarget(
            name: "DaVinciTokensTests",
            dependencies: ["DaVinciTokens"]
        ),
        .testTarget(
            name: "DaVinciComponentsTests",
            dependencies: ["DaVinciComponents", "DaVinciTokens"],
            resources: [.copy("__Snapshots__")]
        )
    ]
)
