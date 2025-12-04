// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Graft",
    platforms: [
        .iOS(.v17),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "Graft",
            targets: ["Graft"]
        )
    ],
    targets: [
        .target(
            name: "Graft",
            dependencies: ["libgraft_ext"],
            linkerSettings: [
                .linkedLibrary("sqlite3"),
            ]
        ),
        .binaryTarget(
            name: "libgraft_ext",
            url: "https://github.com/orbitinghail/graft/releases/download/v0.2.1/libgraft-ext.xcframework.zip",
            checksum: "98856f04b3a5ae51f5e0ce7d7394211f86d522e9a0e73cea34c5c098c561cb09"
        )
    ]
)
