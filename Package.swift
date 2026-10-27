// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LocalDrop",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "LocalDrop", targets: ["LocalDrop"])
    ],
    targets: [
        .executableTarget(name: "LocalDrop"),
        .testTarget(name: "LocalDropTests", dependencies: ["LocalDrop"])
    ]
)
