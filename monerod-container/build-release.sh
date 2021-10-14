#!/usr/bin/env bash

set -Eeuxo pipefail
# set -Eeuo pipefail

monero_release="$(curl -s 'https://api.github.com/repos/monero-project/monero/releases/latest')"
monero_tag="$(jq -r .tag_name <<<"$monero_release")"
monero_bundle="monero-linux-x64-$monero_tag.tar.bz2"
hashes_file="hashes.$monero_tag.txt"
docker_tag="ghcr.io/mkell43/monerod:$monero_tag"

curl -s https://www.getmonero.org/downloads/hashes.txt -o "$hashes_file"
# This is brittle...
# Maybe just hardcode binaryfate?
hashes_signer=$(awk -F '~' '/# ~/ {print tolower($2)}' "$hashes_file")
curl -s "https://raw.githubusercontent.com/monero-project/monero/$monero_tag/utils/gpg_keys/$hashes_signer.asc" | gpg --import
gpg --verify "$hashes_file"
curl -s "https://downloads.getmonero.org/cli/monero-linux-x64-$monero_tag.tar.bz2" -o "$monero_bundle"
sha256_hash=$(sha256sum "$monero_bundle" | cut -c 1-64)
grep -q "$sha256_hash" "$hashes_file"
mkdir monerod
tar -jxf "$monero_bundle" -C monerod/ --strip-components=1
docker build . -t "$docker_tag"
docker push "$docker_tag"
# Use a mask in Github Actions
# https://www.tutorialworks.com/github-actions-mask-url/
echo -n "$(pass monero_project/cosign_key)" | cosign sign --key ../cosign.key "$docker_tag"
