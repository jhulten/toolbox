ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/jhulten/toolbox/base:${BASE_IMAGE_TAG}

LABEL org.opencontainers.image.title="Toolbox Devcontainer"
LABEL org.opencontainers.image.description="Development container image with git, SSH, GPG, and locale support"
LABEL org.opencontainers.image.source="https://github.com/jhulten/toolbox/blob/main/devcontainer/Dockerfile"
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  openssh-client=1:10.0p1-7 \
  gnupg=2.4.7-21 \
  locales=2.41-12 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD git --version || exit 1

USER toolsmith
WORKDIR /home/toolsmith
