// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mock",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Mock",
            targets: ["Mock"])
    ],
    dependencies: [
        .package(path: "../Model")
    ],
    targets: [
        .target(
            name: "Mock",
            dependencies: [
                "Model"
            ]),
        .testTarget(
            name: "MockTests",
            dependencies: ["Mock"])
    ]
)
