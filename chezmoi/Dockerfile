ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/jhulten/toolbox/base:${BASE_IMAGE_TAG}

LABEL org.opencontainers.image.title="Toolbox Chezmoi"
LABEL org.opencontainers.image.description="Container image with chezmoi for dotfiles management"
LABEL org.opencontainers.image.source="https://github.com/jhulten/toolbox"
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

USER toolsmith
WORKDIR /home/toolsmith

# Install chezmoi using mise
ARG CHEZMOI_VERSION=2.56.1
RUN mise use --global aqua:twpayne/chezmoi@${CHEZMOI_VERSION}

# Optional: Initialize chezmoi with a dotfiles repo
# WARNING: This will execute code from the dotfiles repository during build.
# Only use with trusted repositories.
#
# For public repos or repos with token:
#   docker build --build-arg CHEZMOI_REPO=https://github.com/user/dotfiles.git
#   docker build --build-arg CHEZMOI_REPO=https://token@github.com/user/dotfiles.git
#
# For private repos with SSH:
#   docker buildx build --ssh default --build-arg CHEZMOI_REPO=git@github.com:user/dotfiles.git
ARG CHEZMOI_REPO=""
RUN --mount=type=ssh \
  mkdir -p ~/.ssh && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null || true && \
  if [ -n "$CHEZMOI_REPO" ]; then \
    chezmoi init --apply "$CHEZMOI_REPO"; \
  fi

CMD ["/bin/zsh"]
