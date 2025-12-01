FROM debian:13-slim
LABEL maintainer="jhulten"

ARG DOTFILES_REPO="https://github.com/jhulten/dotfiles.git"
ARG DOTFILES_BRANCH="main"
ARG DOTFILES_DIR="/home/toolbox/.dotfiles"

ENV DEBIAN_FRONTEND=noninteractive \
    DOTFILES_REPO=${DOTFILES_REPO} \
    DOTFILES_BRANCH=${DOTFILES_BRANCH} \
    DOTFILES_DIR=${DOTFILES_DIR} \
    HOME=/home/toolbox \
    USER=toolbox

# Install runtime dependencies (git, curl, ca-certificates, zsh optional)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git \
        curl \
        ca-certificates \
        zsh \
        sudo \
        locales \
 && locale-gen en_US.UTF-8 || true \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*

# Create an unprivileged user to own dotfiles and run the shell
RUN useradd -m -s /bin/bash -u 1000 toolbox \
 && echo "toolbox ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/toolbox \
 && chmod 0440 /etc/sudoers.d/toolbox

# Copy entrypoint and make executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
 && chown toolbox:toolbox /usr/local/bin/entrypoint.sh

WORKDIR /home/toolbox

# Default entrypoint will clone/update dotfiles and drop to shell/command as the toolbox user
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# Default to an interactive shell when no command provided
CMD ["bash"]
