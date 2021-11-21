FROM ubuntu:20.04

LABEL org.opencontainers.image.title "p2pool"
LABEL org.opencontainers.image.description "A simple p2pool container."
LABEL org.opencontainers.image.authors "mike.k@blu-web.com"
LABEL org.opencontainers.image.url "https://github.com/mkell43/monero/tree/main/p2pool-container"
LABEL org.opencontainers.image.source "https://github.com/mkell43/monero"
LABEL org.opencontainers.image.base.name "registry.hub.docker.com/library/ubuntu:20.04"

# hadolint ignore=DL3008
RUN set -ex \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get \
  -o Dpkg::Options::=--force-confold \
  -o Dpkg::Options::=--force-confdef \
  -y \
  --allow-downgrades \
  --allow-remove-essential \
  --allow-change-held-packages \
  upgrade \
  && apt-get --no-install-recommends --yes install ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt \
  && adduser --system --group --disabled-password p2pool \
  && mkdir -p /p2pool/ \
  && chown -R p2pool:p2pool /p2pool

COPY p2pool*/p2pool /usr/local/bin/p2pool

# Lock down access to the p2pool binary.
RUN chown root:root /usr/local/bin/p2pool \
  && chmod 551 /usr/local/bin/p2pool

# Expose stratum server port.
EXPOSE 3333
# Expose p2p port.
EXPOSE 37889

USER p2pool
WORKDIR /p2pool

ENTRYPOINT ["p2pool"]
CMD ["--host p2pool", "--stratum 0.0.0.0:3333", "--p2p 0.0.0.0:37889"]
