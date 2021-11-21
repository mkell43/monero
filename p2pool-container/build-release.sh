#!/usr/bin/env bash

set -Eeuxo pipefail
# set -Eeuo pipefail

# Get latestt release tag.
p2pool_tag="$(curl -s 'https://api.github.com/repos/SChernykh/p2pool/releases/latest' | jq -r .tag_name)"

# Retrieve the hashes file.
curl -sLO "https://github.com/SChernykh/p2pool/releases/download/$p2pool_tag/sha256sums.txt.asc"

# Import GPG.
curl -s "https://github.com/Schernykh.gpg" | gpg --import

# Verify signature on hashes file.
gpg --verify sha256sums.txt.asc

# Download release archive.
curl -sLO "https://github.com/SChernykh/p2pool/releases/download/$p2pool_tag/p2pool-$p2pool_tag-linux-x64.tar.gz"

# Verify the `sha256sum` of the release archive.
grep -iq "$(sha256sum "p2pool-$p2pool_tag-linux-x64.tar.gz" | cut -c 1-64)" "sha256sums.txt.asc"

# Extract the release archive.
tar -xzf "p2pool-$p2pool_tag-linux-x64.tar.gz"

docker build . -t "p2pool:testing"
