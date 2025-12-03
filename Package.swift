// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "libgraft-ext",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "libgraft_ext",
            targets: ["libgraft_ext"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "libgraft_ext",
            url: "https://github.com/orbitinghail/graft/releases/download/v0.1.5/libgraft_ext.xcframework.zip",
            checksum: "2ddb8c98f66e5bf28ae7d3b97792eca47f7938a515228955fccd633ca41280ca"
        )
    ]
)
