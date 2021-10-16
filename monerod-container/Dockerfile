FROM ubuntu:20.04
LABEL org.opencontainers.image.authors "mike.k@blu-web.com"
LABEL org.opencontainers.image.url "https://github.com/mkell43/monero/monerod-container/"
LABEL org.opencontainers.image.source "https://github.com/mkell43/monero"

LABEL org.opencontainers.image.title "monerod"
LABEL org.opencontainers.image.description "A simple monerod container."
LABEL org.opencontainers.image.authors "mike.k@blu-web.com"
LABEL org.opencontainers.image.url "https://github.com/mkell43/monero/tree/main/monerod-container"
LABEL org.opencontainers.image.source "https://github.com/mkell43/monero"
LABEL org.opencontainers.image.base.name "registry.hub.docker.com/library/ubuntu:20.04"

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
  && adduser --system --group --disabled-password monerod \
  && mkdir -p /monerod/.bitmonero \
  && chown -R monerod:monerod /monerod

VOLUME /monerod/.bitmonero

COPY monerod/ /usr/local/bin/
RUN chmod 551 /usr/local/bin/monero*

EXPOSE 18080
EXPOSE 18089

USER monerod

HEALTHCHECK --interval=60s --timeout=10s CMD curl --fail http://localhost:18089/get_info || exit 1

ENTRYPOINT ["monerod", "--non-interactive", "--data-dir=/monerod/.bitmonero"]
CMD ["--rpc-restricted-bind-ip=0.0.0.0", "--rpc-restricted-bind-port=18089", "--no-igd", "--no-zmq", "--enable-dns-blocklist"]