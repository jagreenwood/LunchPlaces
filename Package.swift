// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "tools",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [.library(name: "Tools", targets: ["Tools"])],
    dependencies: [
        .package(url: "https://github.com/jagreenwood/DevTools.git", branch: "main")
    ],
    targets: [.target(name: "Tools", dependencies: [])]
)
