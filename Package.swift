// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Graft",
    platforms: [
        .iOS(.v11),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "Graft",
            targets: ["Graft"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Graft",
            url: "https://github.com/orbitinghail/graft/releases/download/v0.2.1/libgraft-ext.xcframework.zip",
            checksum: "98856f04b3a5ae51f5e0ce7d7394211f86d522e9a0e73cea34c5c098c561cb09"
        )
    ]
)
