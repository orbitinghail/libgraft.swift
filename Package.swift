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
            url: "https://github.com/orbitinghail/graft/releases/download/v0.1.5/libgraft.xcframework.zip",
            checksum: "2ddb8c98f66e5bf28ae7d3b97792eca47f7938a515228955fccd633ca41280ca"
        )
    ]
)
