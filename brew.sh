#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

OWNER="sb-community"
REPO="sing-box-premium"

RELEASE_INFO=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/latest")
VERSION=$(echo "$RELEASE_INFO" | jq -r ".tag_name")

DARWIN_ARM_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test("darwin-arm64")) | .browser_download_url')
DARWIN_AMD64_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test("darwin-amd64")) | .browser_download_url')
LINUX_AMD64_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test("linux-amd64")) | .browser_download_url')
LINUX_ARMV8_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test("linux-armv8")) | .browser_download_url')
LINUX_ARMV7_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test("linux-armv7")) | .browser_download_url')

get_sha256() {
  URL=$1
  FILE=$(mktemp)
  curl -sL "$URL" -o "$FILE"
  sha256sum "$FILE" | awk '{print $1}'
  rm "$FILE"
}

DARWIN_ARM_SHA256=$(get_sha256 "$DARWIN_ARM_URL")
DARWIN_AMD64_SHA256=$(get_sha256 "$DARWIN_AMD64_URL")
LINUX_AMD64_SHA256=$(get_sha256 "$LINUX_AMD64_URL")
LINUX_ARMV8_SHA256=$(get_sha256 "$LINUX_ARMV8_URL")
LINUX_ARMV7_SHA256=$(get_sha256 "$LINUX_ARMV7_URL")

TEMPLATE="$SCRIPT_DIR/brew.rb"
OUTPUT="$SCRIPT_DIR/Formula/sing-box-premium.rb"

sed -e "s|{{version}}|$VERSION|g" \
    -e "s|{{darwin_arm_url}}|$DARWIN_ARM_URL|g" \
    -e "s|{{darwin_arm_sha256}}|$DARWIN_ARM_SHA256|g" \
    -e "s|{{darwin_amd64_url}}|$DARWIN_AMD64_URL|g" \
    -e "s|{{darwin_amd64_sha256}}|$DARWIN_AMD64_SHA256|g" \
    -e "s|{{linux_amd64_url}}|$LINUX_AMD64_URL|g" \
    -e "s|{{linux_amd64_sha256}}|$LINUX_AMD64_SHA256|g" \
    -e "s|{{linux_armv8_url}}|$LINUX_ARMV8_URL|g" \
    -e "s|{{linux_armv8_sha256}}|$LINUX_ARMV8_SHA256|g" \
    -e "s|{{linux_armv7_url}}|$LINUX_ARMV7_URL|g" \
    -e "s|{{linux_armv7_sha256}}|$LINUX_ARMV7_SHA256|g" \
    "$TEMPLATE" > "$OUTPUT"

echo "Updated Formula written to $OUTPUT"
