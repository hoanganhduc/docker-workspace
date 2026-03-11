# syntax=docker/dockerfile:1.7
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

RUN --mount=type=cache,id=openclaw-sandbox-bookworm-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=openclaw-sandbox-bookworm-apt-lists,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y --no-install-recommends \
      bash \
      ca-certificates \
      curl \
      git \
      jq \
      ripgrep \
      python3 \
      python3-pip \
      python3-venv \
      python3-dev \
      python3-virtualenv \
      build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 -s /bin/bash ubuntu \
 && mkdir -p /workspace \
 && chown -R 1000:1000 /workspace /home/ubuntu

USER 1000:1000
WORKDIR /workspace

CMD ["sleep", "infinity"]