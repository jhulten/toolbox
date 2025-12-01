FROM ghcr.io/jhulten/toolbox/base:latest

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  git=1:2.47.2-0.2 \
  openssh-client=1:9.9p1-3 \
  gnupg=2.2.46-1 \
  locales=2.40-9 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

USER toolsmith
WORKDIR /home/toolsmith
