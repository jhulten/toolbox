ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/jhulten/toolbox/base:${BASE_IMAGE_TAG}

LABEL maintainer="jhulten"

ARG DOTFILES_REPO="https://github.com/jhulten/dotfiles.git"
ARG DOTFILES_BRANCH="main"
ARG DOTFILES_DIR="/home/toolsmith/.dotfiles"

ENV DEBIAN_FRONTEND=noninteractive \
    DOTFILES_REPO=${DOTFILES_REPO} \
    DOTFILES_BRANCH=${DOTFILES_BRANCH} \
    DOTFILES_DIR=${DOTFILES_DIR} \
    HOME=/home/toolsmith \
    USER=toolsmith

USER root

# Install runtime dependencies (git, zsh, sudo, locales)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git \
        zsh \
        sudo \
        locales \
 && locale-gen en_US.UTF-8 || true \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*

# Grant sudo access to toolsmith user
RUN echo "toolsmith ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/toolsmith \
 && chmod 0440 /etc/sudoers.d/toolsmith

# Copy entrypoint and make executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
 && chown toolsmith:toolsmith /usr/local/bin/entrypoint.sh

USER toolsmith
WORKDIR /home/toolsmith

# Default entrypoint will clone/update dotfiles and drop to shell/command as the toolsmith user
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# Default to an interactive shell when no command provided
CMD ["bash"]
