FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  ca-certificates=20250419\
  curl=8.14.1-2+deb13u2 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

RUN sed -i 's/http:/https:/' /etc/apt/sources.list.d/*

ADD https://mise.jdx.dev/gpg-key.pub /etc/apt/keyrings/mise-archive-keyring.pub
COPY apt/mise.list /etc/apt/sources.list.d/

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  mise=2025.11.11 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

