FROM ghcr.io/hoanganhduc/texlive:latest

# Metadata for the image
LABEL org.opencontainers.image.title="Arch Linux Base Workspace"
LABEL org.opencontainers.image.source="https://github.com/hoanganhduc/docker-workspace"
LABEL org.opencontainers.image.description="A custom Arch Linux installation with packages I often use"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="Duc A. Hoang <anhduc.hoang1990@gmail.com>"

ARG USERNAME=hoanganhduc
ARG USERHOME=/home/hoanganhduc
ARG USERID=1000
ARG USERGECOS='Duc A. Hoang'

RUN useradd \
	--create-home \
	--home-dir "$USERHOME" \
	--password "" \
	--uid "$USERID" \
	--comment "$USERGECOS" \
	--shell /bin/bash \
	"$USERNAME" && \
	echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	
USER $USERNAME
WORKDIR $USERHOME

RUN mkdir -p .gnupg && echo "keyserver hkp://pool.sks-keyservers.net" >> .gnupg/gpg.conf

# pdf2htmlEX

RUN yay -S --needed --noconfirm pdf2htmlex-appimage

# IPE

RUN yay -S --noconfirm --needed ipe

# LaTeX2HTML

RUN yay -S --noconfirm --needed latex2html

# LaTeXML

RUN yay -S --noconfirm --needed perl-latexml

# DocOnce

RUN yay -S --needed --noconfirm python2-virtualenv python2-pip && \
	sudo pip2 install setuptools ipython tornado pyzmq traitlets pickleshare jsonschema pdftools future mako python-Levenshtein lxml sphinx && \
	git clone https://github.com/hoanganhduc/preprocess && cd preprocess && sudo python2 setup.py install && cd .. && sudo rm -rf preprocess && \
	git clone https://github.com/hoanganhduc/logg-publish && cd logg-publish && sudo python2 setup.py install && cd .. && sudo rm -rf logg-publish && \
	git clone https://github.com/hoanganhduc/doconce.git && cd doconce && sudo python2 setup.py install && cd .. && sudo rm -rf doconce

# Jekyll

RUN yay -S --needed --noconfirm ruby rubygems
RUN cd $HOME && \
	gem install bundler && \
	export PATH=/home/hoanganhduc/.gem/ruby/3.0.0/bin:$PATH && \
	wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/master/Gemfile && \
	wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/master/Gemfile.lock &&  \
	bundle install && \
	rm -rf Gemfile Gemfile.lock
	
# Remove more unnecessary stuff
RUN yes | yay -Scc

