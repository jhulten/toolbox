ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/jhulten/toolbox/base:${BASE_IMAGE_TAG}

LABEL org.opencontainers.image.title="Toolbox Chezmoi"
LABEL org.opencontainers.image.description="Container image with chezmoi for dotfiles management"
LABEL org.opencontainers.image.source="https://github.com/jhulten/toolbox"
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Install git (required by chezmoi)
RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  git=1:2.47.3-0+deb13u1 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

# Install chezmoi
ARG CHEZMOI_VERSION=2.56.1
RUN curl -sfL https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_amd64.tar.gz | \
  tar -xz -C /usr/local/bin chezmoi &&\
  chmod +x /usr/local/bin/chezmoi

USER toolsmith
WORKDIR /home/toolsmith

# Optional: Initialize chezmoi with a dotfiles repo
ARG CHEZMOI_REPO=""
RUN if [ -n "$CHEZMOI_REPO" ]; then \
  chezmoi init --apply "$CHEZMOI_REPO"; \
  fi
