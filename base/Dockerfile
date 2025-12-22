FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  ca-certificates=20250419 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

RUN sed -i 's/http:/https:/' /etc/apt/sources.list.d/*

ADD --chmod=644 https://mise.jdx.dev/gpg-key.pub /etc/apt/keyrings/mise-archive-keyring.pub
COPY apt/mise.list /etc/apt/sources.list.d/

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  curl=8.14.1-2+deb13u2 \
  zsh=5.9-8+b14 \
  mise=2025.12.12 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

RUN groupadd -r toolsmith && useradd -m -s /bin/zsh -g toolsmith toolsmith

USER toolsmith
