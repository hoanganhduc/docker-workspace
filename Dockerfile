FROM archlinux:latest
LABEL author="Duc A. Hoang"

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

# Some necessary tools

RUN pacman -Syy && \
	pacman -S --needed --noconfirm base base-devel cmake wget curl git sudo openssh tree rsync

# Build pdf2htmlEX

RUN pacman -S --needed --noconfirm poppler poppler-glib poppler-data poppler-qt5 libxi pango giflib libtool desktop-file-utils gtk-update-icon-cache gc python shared-mime-info openjpeg2 qt5-base && \
	wget https://archive.org/download/archlinux_pkg_automake/automake-1.15-1-any.pkg.tar.xz && \
	pacman -U --noconfirm automake-1.15-1-any.pkg.tar.xz && \
	rm -rf automake-1.15-1-any.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/libunicodenames-1.2.2-1-x86_64.pkg.tar.zst && \
	pacman -U --noconfirm libunicodenames-1.2.2-1-x86_64.pkg.tar.zst && \
	rm -rf libunicodenames-1.2.2-1-x86_64.pkg.tar.zst

# Poppler 0.59.0
RUN wget https://poppler.freedesktop.org/poppler-0.59.0.tar.xz && \
	tar -xvf poppler-0.59.0.tar.xz && \
	cd poppler-0.59.0/ &&\
	./configure --prefix=/usr/local --enable-xpdf-headers && \
	make && \
	make install && \
	ln -sf /usr/local/lib/libpoppler.so.70 /usr/lib/libpoppler.so.70 && \
	cd .. && rm -rf poppler-0.59.0*

# Fontforge
RUN curl -O https://download.libsodium.org/libsodium/releases/old/unsupported/libsodium-0.7.1.tar.gz && \
	tar xvf libsodium-0.7.1.tar.gz && \
	cd libsodium-0.7.1/ && \
	./configure --prefix=/usr/local && \
	make && \
	make install && \
	ln -sf /usr/local/lib/libsodium.so.13 /usr/lib/libsodium.so.13 && \
	cd .. && rm -rf libsodium-0.7.1* && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/readline6-6.3.008-4-x86_64.pkg.tar.zst && pacman -U --noconfirm readline6-6.3.008-4-x86_64.pkg.tar.zst && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/zeromq-4.0.6-1-x86_64.pkg.tar.xz && pacman -U --noconfirm zeromq-4.0.6-1-x86_64.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/libxkbui-1.0.2-6-x86_64.pkg.tar.xz && pacman -U --noconfirm libxkbui-1.0.2-6-x86_64.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/libspiro-1%3A0.5.20150702-2-x86_64.pkg.tar.xz && pacman -U --noconfirm libspiro-1:0.5.20150702-2-x86_64.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/fontforge-20141126-3-x86_64.pkg.tar.xz && pacman -U --noconfirm fontforge-20141126-3-x86_64.pkg.tar.xz && \
	rm -rf *.pkg.tar.*

# pdf2htmlEX
#RUN git clone --depth 1 https://github.com/coolwanglu/pdf2htmlEX.git && cd pdf2htmlEX/ && cmake . && make && make install && cd .. && rm -rf pdf2htmlEX
RUN wget https://hoanganhduc.github.io/archlinux/x86_64/pdf2htmlex-git-1_1742.f12fc15-3-x86_64.pkg.tar.xz && pacman -U --noconfirm pdf2htmlex-git-1_1742.f12fc15-3-x86_64.pkg.tar.xz && \
	rm -rf *.pkg.tar.*

# TeXLive 2019

RUN pacman -S --needed --noconfirm texlive-most texlive-lang biber

# Java

RUN pacman -S --needed --noconfirm jdk11-openjdk jre11-openjdk jdk8-openjdk jre8-openjdk # version 8 and 11
RUN pacman -S --needed --noconfirm jdk-openjdk jre-openjdk # latest java

# LaTeXML

RUN pacman -S --needed --noconfirm perl-latexml

# IPE

RUN pacman -S --noconfirm --needed lua53 qt5-base qt5-svg freetype2 zlib poppler hicolor-icon-theme gsl && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/ipe-7.2.21-1-x86_64.pkg.tar.zst && pacman -U --noconfirm ipe-7.2.21-1-x86_64.pkg.tar.zst && \
	rm -rf *.pkg.tar.*

# LaTeX2HTML

RUN pacman -S --noconfirm --needed latex2html

# DocOnce

RUN pacman -S --needed --noconfirm python2-virtualenv python2-pip && \
	pip2 install setuptools ipython tornado pyzmq traitlets pickleshare jsonschema pdftools future mako python-Levenshtein lxml sphinx && \
	git clone https://github.com/hoanganhduc/preprocess && cd preprocess && python2 setup.py install && cd .. && rm -rf preprocess && \
	git clone https://github.com/hoanganhduc/logg-publish && cd logg-publish && python2 setup.py install && cd .. && rm -rf logg-publish && \
	git clone https://github.com/hoanganhduc/doconce.git && cd doconce && python2 setup.py install

# Remove more unnecessary stuff
RUN apt-get --purge remove -y .\*-doc$
RUN apt-get clean -y

# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

USER $USERNAME

# Jekyll

RUN sudo pacman -S --needed --noconfirm ruby ruby-dev
RUN cd $HOME && \
	gem install bundler && \
	wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/master/Gemfile && \
	wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/master/Gemfile.lock &&  \
	bundle install && \
	rm -rf Gemfile Gemfile.lock

