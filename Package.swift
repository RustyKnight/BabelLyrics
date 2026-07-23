// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BabelLyrics",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "BabelLyrics",
            targets: ["BabelLyrics"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/RustyKnight/BabelLyricsLib", branch: "main"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "BabelLyrics",
            dependencies: [
                .product(name: "BabelLyricsLib", package: "BabelLyricsLib"),
                .product(name: "Rainbow", package: "Rainbow"),
            ]
        ),
        .testTarget(
            name: "BabelLyricsTests",
            dependencies: [
                "BabelLyrics",
                .product(name: "BabelLyricsLib", package: "BabelLyricsLib"),
                .product(name: "Rainbow", package: "Rainbow"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
