// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Graft",
    platforms: [
        .iOS(.v11)
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
            url: "https://github.com/orbitinghail/graft/releases/download/v0.2.0/libgraft-ext.xcframework.zip",
            checksum: "c824c34a50445998a1874d02a58db8d30f7622b3ab98c7711638cb427498ddfb"
        )
    ]
)
