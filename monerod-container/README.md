# monerod-docker

This is a customized monerod container image.

[![Build Monerod Container Image](https://github.com/mkell43/monero/actions/workflows/monerod-container.yml/badge.svg)](https://github.com/mkell43/monero/actions/workflows/monerod-container.yml)

## Usage

I use the `latest` tag in the examples below, which is fine, but I recommend running a specific version like `ghcr.io/mkell43/monerod:v0.17.2.3`. The version tag reflects the version of `monero` used while building the container image.

If you're using something like [`containrrr/watchtower`](https://github.com/containrrr/watchtower/) then you'll want to ignore my recommendation and use the `latest` tag. Or you know, just live your best life and do what you want.

### Optional First Step

| This is optional, but _highly encourage_. |
| ----------------------------------------- |


- Install [`cosign`](https://github.com/sigstore/cosign) if you don't already have it.
- `wget https://raw.githubusercontent.com/mkell43/monero/main/cosign.pub`
- `cosign verify --key cosign.pub ghcr.io/mkell43/monerod:latest`

This current method isn't sustainable as I don't use a git tag on the repo to tie a specific tagged version of the container image to a version of the public key. I'm working on it and will fix it up *soon*™.

### Running the Container

- `docker run -d --name monerod --restart unless-stopped -v bitmonero:/home/monerod ghcr.io/mkell43/monerod:latest --rpc-restricted-bind-ip=0.0.0.0 --rpc-restricted-bind-port=18089 --no-igd --no-zmq --enable-dns-blocklist`

Above, I'm passing a number of arguments without any explanation. If you don't know what they are or what they do, you should totally check out the great documentation at the appropriately named [Monero Docs](https://monerodocs.org/interacting/monerod-reference/) site. **Pleas don't run things all willy nilly without knowing what you're telling it to do!** _Please._

## How Are The Binaries Verified?

In order to make sure that we've actually got the right we follow the process documented at [MoneroDocs.org](https://monerodocs.org/interacting/verify-monero-binaries/) ([Archived Page](https://web.archive.org/web/20211121195837/https://monerodocs.org/interacting/verify-monero-binaries/#verify-monero-binaries)).

The process can be viewed in the `monerod-container.yml` GHA workflow file, but here's an outline as well:

1. Get `hashes.txt` from [getmonero.org](https://www.getmonero.org/downloads/hashes.txt).
2. Import binaryfate's GPG.
3. Verify the GPG signature on the hashes file retrieved earlier.
4. Download the Monero release archive and confirm the `sha256sum` hash matches what is listed in the hashes file.
