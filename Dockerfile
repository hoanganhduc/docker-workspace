FROM python:3.12-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver

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
    chromium \
    chromium-driver \
    pdftk \
    texlive-full \
    fonts-lmodern \
    texlive-latex-extra \
    texlive-lang-all \
    latexmk \
    texlive-xetex \
    texlive-luatex \
    ghostscript \
 && rm -rf /var/lib/apt/lists/*

RUN curl -O https://downloads.rclone.org/rclone-current-linux-arm64.zip && \
    unzip rclone-current-linux-arm64.zip && \
    cp rclone-*-linux-arm64/rclone /usr/local/bin/ && \
    chmod +x /usr/local/bin/rclone && \
    rm -rf rclone-*-linux-arm64* && \
    rclone version

RUN useradd -m -u 1001 -s /bin/bash ubuntu \
 && mkdir -p /workspace \
 && chown -R 1001:1001 /workspace

USER 1001:1001
WORKDIR /workspace

CMD ["sleep", "infinity"]