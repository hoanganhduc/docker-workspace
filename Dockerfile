# Dockerfile.sandbox.custom
FROM openclaw-sandbox-common:bookworm-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
	python3 \
	python3-venv \
	python3-pip \
	python3-dev \
	build-essential \
	git \
	curl \
	jq \
	sudo \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
	texlive-full \
 && rm -rf /var/lib/apt/lists/*

# Create user 'ubuntu' with no password and add to sudoers
RUN useradd -m -s /bin/bash ubuntu && \
	usermod -aG sudo ubuntu && \
	echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ubuntu
WORKDIR /workspace

