ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/jhulten/toolbox/base:${BASE_IMAGE_TAG}

LABEL org.opencontainers.image.title="Toolbox Chezmoi"
LABEL org.opencontainers.image.description="Container image with chezmoi for dotfiles management"
LABEL org.opencontainers.image.source="https://github.com/jhulten/toolbox"
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Install chezmoi using the official installation script
ARG CHEZMOI_VERSION=2.56.1
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin -t v${CHEZMOI_VERSION}

USER toolsmith
WORKDIR /home/toolsmith

# Optional: Initialize chezmoi with a dotfiles repo
# WARNING: This will execute code from the dotfiles repository during build.
# Only use with trusted repositories.
ARG CHEZMOI_REPO=""
RUN if [ -n "$CHEZMOI_REPO" ]; then \
  chezmoi init --apply "$CHEZMOI_REPO" || exit 1; \
  fi
