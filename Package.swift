// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "libgraft",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "libgraft",
            targets: ["libgraft"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "libgraft",
            url: "https://github.com/orbitinghail/graft/releases/download/v0.1.4/libgraft.xcframework.tar.gz",
            checksum: "<PUT_CHECKSUM_HERE>"
        )
    ]
)
