// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "LocationAccess", targets: ["LocationAccess"]),
        .library(name: "LocationService", targets: ["LocationService"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Mock"),
        .package(path: "../PlacesAPI"),
        .package(path: "../UIComponents"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.34.0"),
        .package(url: "https://github.com/pointfreeco/swift-overture.git", from: "0.5.0"),
        .package(url: "https://github.com/pointfreeco/composable-core-location.git", from: "0.2.0")
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
        .target(
            name: "LocationAccess",
            dependencies: [
                "Common",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "LocationService",
            dependencies: [
                "Common",
                .product(name: "ComposableCoreLocation", package: "composable-core-location")
            ]),

        .testTarget(
            name: "FeaturesTests",
            dependencies: [
                "App",
                "Common",
                "Mock",
                "LocationService",
                "LocationAccess",
                .product(name: "Overture", package: "swift-overture")
            ])
    ]
)
