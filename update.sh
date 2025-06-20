#!/usr/bin/env bash
set -euo pipefail

REPO="orbitinghail/graft"
XC_NAME="libgraft.xcframework.tar.gz"

# 1. Get latest release tag
LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r .tag_name)

# 2. Build URL
URL="https://github.com/$REPO/releases/download/$LATEST_TAG/$XC_NAME"

# 3. Create temp dir and download
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

curl -L -o "$TMPDIR/$XC_NAME" "$URL"

# 4. Compute checksum
CHECKSUM=$(swift package compute-checksum "$TMPDIR/$XC_NAME")

# 5. Output Package.swift
cat <<EOF
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
            url: "$URL",
            checksum: "$CHECKSUM"
        )
    ]
)
EOF
