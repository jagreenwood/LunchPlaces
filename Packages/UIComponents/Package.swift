// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"])
    ],
    dependencies: [
        .package(path: "../Localization")
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: [
                "Localization"
            ])
    ]
)
