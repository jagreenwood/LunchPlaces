// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Model",
            targets: ["Model"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Model",
            dependencies: []),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model"])
    ]
)
