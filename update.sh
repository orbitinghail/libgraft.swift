#!/usr/bin/env bash
set -euo pipefail

REPO="orbitinghail/graft"
XC_NAME="libgraft.xcframework.tar.gz"

# 1. Get latest release tag
LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r .tag_name)

echo "Updating package to $LATEST_TAG"

# 2. Build URL
URL="https://github.com/$REPO/releases/download/$LATEST_TAG/$XC_NAME"

# 3. Create temp dir and download
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading $URL"
curl -sL -o "$TMPDIR/$XC_NAME" "$URL"

# 4. Compute checksum
echo "Checksumming $XC_NAME"
CHECKSUM=$(swift package compute-checksum "$TMPDIR/$XC_NAME")
echo "Checksum: $CHECKSUM"

# 5. Check if checksum changed using checksum.txt
CHECKSUM_FILE="checksum.txt"
if [[ -f "$CHECKSUM_FILE" ]]; then
    CURRENT_CHECKSUM=$(cat "$CHECKSUM_FILE")
    if [[ "$CHECKSUM" == "$CURRENT_CHECKSUM" ]]; then
        echo "Checksum unchanged ($CHECKSUM). No update needed."
        exit 0
    fi
fi

# 6. Output Package.swift
cat <<EOF >Package.swift
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

# 7. Write new checksum to checksum.txt
echo "$CHECKSUM" > "$CHECKSUM_FILE"

# 8. commit the change and tag it
git add Package.swift "$CHECKSUM_FILE"
git commit -m "Update to $LATEST_TAG"
git tag "$LATEST_TAG"
