FROM python:3.12-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    ripgrep \
    build-essential \
    libqpdf-dev \
    libjpeg-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1001 -s /bin/bash ubuntu \
 && mkdir -p /workspace \
 && chown -R 1001:1001 /workspace

USER 1001:1001
WORKDIR /workspace

CMD ["sleep", "infinity"]