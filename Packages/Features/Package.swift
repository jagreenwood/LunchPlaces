// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "Common", targets: ["Common"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Mock"),
        .package(path: "../PlacesAPI"),
        .package(path: "../UIComponents"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.34.0"),
        .package(url: "https://github.com/pointfreeco/swift-overture", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                "Core",
                "Mock",
                "PlacesAPI",
                "UIComponents",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "App",
            dependencies: [
                "Common",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .testTarget(
            name: "FeaturesTests",
            dependencies: [
                "Common",
                "Mock",
                .product(name: "Overture", package: "swift-overture")
            ])
    ]
)
