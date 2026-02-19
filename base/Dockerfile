FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  ca-certificates=20250419 &&\
  curl=8.14.1-2+deb13u2 \
  zsh=5.9-8+b14 \
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

RUN sed -i 's/http:/https:/' /etc/apt/sources.list.d/*
ADD --chmod=755 --chown=root:root scripts/* /usr/local/bin/
ADD --chown=root:root mise.toml /etc/

RUN groupadd -r toolsmith && useradd -m -s /bin/zsh -g toolsmith toolsmith
USER toolsmith

WORKDIR /home/toolsmith
RUN mise self-update -y
