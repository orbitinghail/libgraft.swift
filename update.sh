#!/usr/bin/env bash
set -euo pipefail

REPO="orbitinghail/graft"
XC_NAME="libgraft_ext.xcframework.zip"

# 1. Get latest release tag
LATEST_TAG=$(curl -fs "https://api.github.com/repos/$REPO/releases/latest" | jq -r .tag_name)

# verify latest tag matches semver
if [[ ! "$LATEST_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: Latest tag '$LATEST_TAG' does not match semver format." >&2
    exit 1
fi

# strip the `v` prefix for our version number to match what Swift expects
VERSION=${LATEST_TAG#v}

echo "Updating package to $LATEST_TAG"

# 2. Build URL
URL="https://github.com/$REPO/releases/download/$LATEST_TAG/$XC_NAME"

# 3. Create temp dir and download
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading $URL"
curl -fsL -o "$TMPDIR/$XC_NAME" "$URL"

# 4. Compute checksum
echo "Checksumming $XC_NAME"
CHECKSUM=$(swift package compute-checksum "$TMPDIR/$XC_NAME")
echo "Checksum: $CHECKSUM"

# 5. Verify: checksum changes <=> version changes
CHECKSUM_FILE="checksum.txt"
CURRENT_CHECKSUM=""
[[ -f "$CHECKSUM_FILE" ]] && CURRENT_CHECKSUM=$(<"$CHECKSUM_FILE")

CURRENT_TAG=$(git describe --tags --abbrev=0 2>/dev/null || true)

version_changed=0
[[ "$VERSION" != "$CURRENT_TAG" ]] && version_changed=1

checksum_changed=0
[[ "$CHECKSUM" != "$CURRENT_CHECKSUM" ]] && checksum_changed=1

if (( version_changed != checksum_changed )); then
    echo "ERROR: version_changed=${version_changed}, checksum_changed=${checksum_changed}; they must match." >&2
    exit 1
fi

# Nothing changed → exit early
if (( version_changed == 0 )); then
    echo "No update needed."
    exit 0
fi

# 6. Output Package.swift
cat <<EOF >Package.swift
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
git commit -m "Update to $VERSION"
git tag "$VERSION"
