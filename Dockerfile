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

# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

# Some necessary tools

RUN pacman -Syy && \
	pacman -S --needed --noconfirm base base-devel cmake wget curl git sudo openssh tree rsync gnupg
	
USER $USERNAME
WORKDIR $USERHOME

RUN mkdir -p .gnupg && echo "keyserver hkp://pool.sks-keyservers.net" >> .gnupg/gpg.conf

# yay

#RUN git clone https://aur.archlinux.org/yay && \
#	cd yay && \
#	makepkg -si --noconfirm --needed && \
#	cd .. && rm -rf yay

RUN wget https://hoanganhduc.github.io/archlinux/x86_64/yay-10.0.4-1-x86_64.pkg.tar.zst && \
	sudo pacman -U --noconfirm --needed yay-10.0.4-1-x86_64.pkg.tar.zst && \
	rm -rf yay-10.0.4-1-x86_64.pkg.tar.zst
	
# Java

RUN yay -S --needed --noconfirm jdk-openjdk jre-openjdk # latest java
RUN yay -S --needed --noconfirm jdk11-openjdk jre11-openjdk jdk8-openjdk jre8-openjdk # version 8 and 11

# pdf2htmlEX

RUN yay -S --needed --noconfirm poppler-data && \
	yay -S --needed --noconfirm poppler poppler-glib poppler-qt5 libxi pango giflib libtool desktop-file-utils gtk-update-icon-cache gc python shared-mime-info openjpeg qt5-base && \
	wget https://archive.org/download/archlinux_pkg_automake/automake-1.15-1-any.pkg.tar.xz && \
	sudo pacman -U --noconfirm automake-1.15-1-any.pkg.tar.xz && \
	rm -rf automake-1.15-1-any.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/libunicodenames-1.2.2-1-x86_64.pkg.tar.zst && \
	sudo pacman -U --noconfirm libunicodenames-1.2.2-1-x86_64.pkg.tar.zst && \
	rm -rf libunicodenames-1.2.2-1-x86_64.pkg.tar.zst

## Fontforge

RUN yay -S --noconfirm --needed readline6 && \
	wget https://archive.org/download/archlinux_pkg_libsodium/libsodium-0.7.1-1-x86_64.pkg.tar.xz && sudo pacman -U --noconfirm libsodium-0.7.1-1-x86_64.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/zeromq-4.0.6-1-x86_64.pkg.tar.xz && sudo pacman -U --noconfirm zeromq-4.0.6-1-x86_64.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/libxkbui-1.0.2-6-x86_64.pkg.tar.xz && sudo pacman -U --noconfirm libxkbui-1.0.2-6-x86_64.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/libspiro-1%3A0.5.20150702-2-x86_64.pkg.tar.xz && sudo pacman -U --noconfirm libspiro-1:0.5.20150702-2-x86_64.pkg.tar.xz && \
	wget https://hoanganhduc.github.io/archlinux/x86_64/fontforge-20141126-3-x86_64.pkg.tar.xz && sudo pacman -U --noconfirm fontforge-20141126-3-x86_64.pkg.tar.xz && \
	rm -rf *.pkg.tar.*

RUN wget https://poppler.freedesktop.org/poppler-0.59.0.tar.xz && \
	tar -xvf poppler-0.59.0.tar.xz && \
	cd poppler-0.59.0/ &&\
	./configure --prefix=/usr/local --enable-xpdf-headers && \
	make && \
	sudo make install && \
	sudo ln -sf /usr/local/lib/libpoppler.so.70 /usr/lib/libpoppler.so.70 && \
	cd .. && rm -rf poppler-0.59.0*
	
RUN sudo pacman -S --noconfirm --needed libsodium && \
	curl -O https://download.libsodium.org/libsodium/releases/old/unsupported/libsodium-0.7.1.tar.gz && \
	tar xvf libsodium-0.7.1.tar.gz && \
	cd libsodium-0.7.1/ && \
	./configure --prefix=/usr/local && \
	make && \
	sudo make install && \
	sudo ln -sf /usr/local/lib/libsodium.so.13 /usr/lib/libsodium.so.13 && \
	cd .. && rm -rf libsodium-0.7.1*

## pdf2htmlEX
#RUN git clone --depth 1 https://github.com/coolwanglu/pdf2htmlEX.git && cd pdf2htmlEX/ && cmake . && make && sudo make install && cd .. && rm -rf pdf2htmlEX
#RUN yay -S --needed --noconfirm pdf2htmlex-git
RUN wget https://hoanganhduc.github.io/archlinux/x86_64/pdf2htmlex-git-1_1742.f12fc15-3-x86_64.pkg.tar.xz && \
	sudo pacman -U --noconfirm --needed pdf2htmlex-git-1_1742.f12fc15-3-x86_64.pkg.tar.xz && \
	rm -rf pdf2htmlex-git-1_1742.f12fc15-3-x86_64.pkg.tar.xz
	
# TeXLive 2020

RUN yay -S --needed --noconfirm texlive-most texlive-lang biber

# IPE

RUN yay -S --noconfirm --needed ipe

# LaTeX2HTML

RUN yay -S --noconfirm --needed latex2html

# LaTeXML

RUN yay -S --noconfirm --needed perl-latexml

# DocOnce

RUN yay -S --needed --noconfirm python2-virtualenv python2-pip && \
	sudo pip2 install setuptools ipython tornado pyzmq traitlets pickleshare jsonschema pdftools future mako python-Levenshtein lxml sphinx && \
	git clone https://github.com/hoanganhduc/preprocess && cd preprocess && sudo python2 setup.py install && cd .. && rm -rf preprocess && \
	git clone https://github.com/hoanganhduc/logg-publish && cd logg-publish && sudo python2 setup.py install && cd .. && rm -rf logg-publish && \
	git clone https://github.com/hoanganhduc/doconce.git && cd doconce && sudo python2 setup.py install

# Jekyll

RUN yay -S --needed --noconfirm ruby ruby-dev
RUN cd $HOME && \
	gem install bundler && \
	wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/master/Gemfile && \
	wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/master/Gemfile.lock &&  \
	bundle install && \
	rm -rf Gemfile Gemfile.lock
	
# Remove more unnecessary stuff
RUN yes | yay -Scc

