// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Test",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "Test",
            targets: ["Test"]
        ),
    ],
    dependencies: [
        // Pull in Graft as a dependency from the parent directory
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "Test",
            dependencies: [
                .product(name: "Graft", package: "Graft.swift"),
            ]
        ),
    ]
)
