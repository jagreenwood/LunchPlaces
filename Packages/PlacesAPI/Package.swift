// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlacesAPI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "PlacesAPI",
            targets: ["PlacesAPI"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Model"),
        .package(url: "http://github.com/objcio/tiny-networking.git", branch: "master")
    ],
    targets: [
        .target(
            name: "PlacesAPI",
            dependencies: [
                "Core",
                "Model",
                .product(name: "TinyNetworking", package: "tiny-networking")
            ]),
        .testTarget(
            name: "PlacesAPITests",
            dependencies: ["PlacesAPI"])
    ]
)
