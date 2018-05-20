FROM ubuntu:16.04

ARG USERNAME=latex
ARG USERHOME=/home/latex
ARG USERID=1000
ARG USERGECOS=LaTEX

RUN adduser \
  --home "$USERHOME" \
  --uid $USERID \
  --gecos "$USERGECOS" \
  --disabled-password \
  "$USERNAME"

ARG WGET=wget
ARG GIT=git
ARG MAKE=make
ARG PANDOC=pandoc
ARG PYGMENTS=python-pygments

RUN apt-get update && apt-get install -y \
  texlive-full \
  # some auxiliary tools
  "$WGET" \
  "$GIT" \
  "$MAKE" \
  # markup format conversion tool
  "$PANDOC" \
  # Required for syntax highlighting using minted.
  "$PYGMENTS" && \
  # Removing documentation packages *after* installing them is kind of hacky,
  # but it only adds some overhead while building the image.
  apt-get --purge remove -y .\*-doc$

# Build LaTeXML

RUN apt-get install -yqq libarchive-zip-perl libfile-which-perl libimage-size-perl libio-string-perl libjson-xs-perl libtext-unidecode-perl libparse-recdescent-perl liburi-perl libuuid-tiny-perl libwww-perl libxml2 libxml-libxml-perl libxslt1.1 libxml-libxslt-perl imagemagick libimage-magick-perl 

RUN git clone https://github.com/hoanganhduc/LaTeXML.git && cd LaTeXML && perl Makefile.PL && make && make install && cd .. && rm -rf LaTeXML

# Buile IPE

RUN apt-get install -yqq checkinstall zlib1g-dev qtbase5-dev qtbase5-dev-tools libfreetype6-dev libcairo2-dev libjpeg8-dev libpng12-dev liblua5.3-dev

RUN wget https://dl.bintray.com/otfried/generic/ipe/7.2/ipe-7.2.7-src.tar.gz && tar -xvf ipe-7.2.7-src.tar.gz && cd ipe-7.2.7/src && export QT_SELECT=5 && make IPEPREFIX=/usr/local && checkinstall --pkgname=ipe --pkgversion=7.2.7 --backup=no --fstrans=no --default make install IPEPREFIX=/usr/local && ldconfig && cd ../.. && rm -rf ipe-7.2.7*

# Remove more unnecessary stuff
RUN apt-get clean -y

