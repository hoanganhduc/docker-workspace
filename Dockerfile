FROM ubuntu:16.04

ARG USERNAME=hoanganhduc
ARG USERHOME=/home/hoanganhduc
ARG USERID=1000
ARG USERGECOS='Duc A. Hoang'

RUN adduser \
  --home "$USERHOME" \
  --uid $USERID \
  --gecos "$USERGECOS" \
  --disabled-password \
  "$USERNAME"

# Some necessary tools

RUN apt-get update && apt-get install -y software-properties-common wget make git git-core build-essential locales sudo pandoc python-pygments ssh subversion git git-core mercurial mercurial-common secure-delete wipe tree bibtex2html fontconfig

# Build pdf2htmlEX

RUN apt-get install -qq -y cmake gcc libgetopt++-dev pkg-config libopenjpeg-dev libfontconfig1-dev libfontforge-dev poppler-data poppler-utils poppler-dbg

# Poppler 0.43.0
RUN wget "https://poppler.freedesktop.org/poppler-0.43.0.tar.xz" --no-check-certificate && tar -xvf poppler-0.43.0.tar.xz && cd poppler-0.43.0/ && ./configure --enable-xpdf-headers && make && make install && cd .. && rm -rf poppler*

# Fontforge
RUN apt-get install -qq -y packaging-dev pkg-config python-dev libpango1.0-dev libglib2.0-dev libxml2-dev giflib-dbg libjpeg-dev libtiff-dev uthash-dev libspiro-dev

#RUN git clone --depth 1 https://github.com/coolwanglu/fontforge.git && cd fontforge/ && ./bootstrap && ./configure && make && make install && cd .. && rm -rf fontforge

# pdf2htmlEX
#RUN git clone --depth 1 https://github.com/coolwanglu/pdf2htmlEX.git && cd pdf2htmlEX/ && cmake . && make && make install && cd .. && rm -rf pdf2htmlEX
RUN apt-get install -y pdf2htmlex

# tzdata

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/t/tzdata/tzdata_2016d-0ubuntu0.16.04_all.deb && dpkg -i tzdata_2016d-0ubuntu0.16.04_all.deb && rm -rf tzdata_2016d-0ubuntu0.16.04_all.deb 

# Extract and Compression

RUN apt-get install -y unace unrar unzip zip lrzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller

# TeXLive 2019

RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && tar -xvf install-tl-unx.tar.gz && cd install-tl-* && ./install-tl --profile=../texlive.profile && cd .. && rm -rf install-tl-* texlive.profile
RUN echo "MANPATH=/usr/local/texlive/2019/texmf-dist/doc/man:$MANPATH; export MANPATH" >> /etc/bash.bashrc
RUN echo "INFOPATH=/usr/local/texlive/2019/texmf-dist/doc/info:$INFOPATH; export INFOPATH" >> /etc/bash.bashrc
RUN echo "PATH=/usr/local/texlive/2019/bin/x86_64-linux:$PATH; export PATH" >> /etc/bash.bashrc
RUN echo "MANPATH_MAP /usr/local/texlive/2019/bin/x86_64-linux /usr/local/texlive/2019/texmf-dist/doc/man" >> /etc/manpath.config
RUN wget http://tug.org/fonts/getnonfreefonts/install-getnonfreefonts && texlua install-getnonfreefonts && getnonfreefonts --sys -a && fc-cache -fv && rm -rf install-getnonfreefonts

# Java

RUN apt-get install -y default-jdk

# Build LaTeXML

RUN apt-get install -yqq libarchive-zip-perl libfile-which-perl libimage-size-perl libio-string-perl libjson-xs-perl libtext-unidecode-perl libparse-recdescent-perl liburi-perl libuuid-tiny-perl libwww-perl libxml2 libxml-libxml-perl libxslt1.1 libxml-libxslt-perl imagemagick libimage-magick-perl 

RUN git clone https://github.com/brucemiller/LaTeXML.git && cd LaTeXML && perl Makefile.PL && make && make install && cd .. && rm -rf LaTeXML

# Buile IPE

RUN apt-get install -yqq checkinstall zlib1g-dev qtbase5-dev qtbase5-dev-tools libfreetype6-dev libcairo2-dev libjpeg8-dev libpng12-dev liblua5.3-dev

RUN wget https://dl.bintray.com/otfried/generic/ipe/7.2/ipe-7.2.12-src.tar.gz && tar -xvf ipe-7.2.12-src.tar.gz && cd ipe-7.2.12/src && export QT_SELECT=5 && make IPEPREFIX=/usr/local && checkinstall --pkgname=ipe --pkgversion=7.2.12 --backup=no --fstrans=no --default make install IPEPREFIX=/usr/local && ldconfig && cd ../.. && rm -rf ipe-7.2.12*

# Build LaTeX2HTML

RUN apt-get install -y netpbm libnetpbm10 libnetpbm10-dev

RUN git clone https://github.com/latex2html/latex2html.git && cd latex2html && ./configure && make && make install && cd .. && rm -rf latex2html

# Build DocOnce

RUN apt-get install -yqq mercurial subversion python-pip idle python-dev python-setuptools python-pdftools

RUN pip install --upgrade pip

RUN pip install setuptools ipython tornado pyzmq traitlets pickleshare jsonschema

## Preprocessors

RUN pip install future mako
RUN pip install -e git+https://github.com/doconce/preprocess#egg=preprocess

# Publish for handling bibliography
RUN apt-get install -yqq libxml2-dev libxslt1-dev zlib1g-dev
RUN pip install python-Levenshtein lxml
RUN pip install -e hg+https://bitbucket.org/logg/publish#egg=publish

# Sphinx (with additional third/party themes)
RUN pip install sphinx alabaster sphinx_rtd_theme
RUN pip install -e hg+https://bitbucket.org/ecollins/cloud_sptheme#egg=cloud_sptheme
RUN pip install -e git+https://github.com/ryan-roemer/sphinx-bootstrap-theme#egg=sphinx-bootstrap-theme
RUN pip install -e hg+https://bitbucket.org/miiton/sphinxjp.themes.solarized#egg=sphinxjp.themes.solarized
RUN pip install -e git+https://github.com/shkumagai/sphinxjp.themes.impressjs#egg=sphinxjp.themes.impressjs
RUN pip install -e git+https://github.com/kriskda/sphinx-sagecell#egg=sphinx-sagecell
RUN pip install sphinxcontrib-paverutils paver cogapp
RUN pip install -e git+https://bitbucket.org/hplbit/pygments-ipython-console#egg=pygments-ipython-console
RUN pip install -e git+https://github.com/hplgit/pygments-doconce#egg=pygments-doconce

# XHTML
RUN pip install beautifulsoup4 html5lib

# Image manipulation
RUN apt-get install -yqq imagemagick inkscape netpbm mjpegtools pdftk giftrans gv

# DocOnce
RUN git clone https://github.com/hoanganhduc/doconce.git && cd doconce && python setup.py install && cd .. && rm -rf doconce

# Build git-latexdiff

RUN apt-get install -yqq asciidoc && git clone https://gitlab.com/git-latexdiff/git-latexdiff.git && cd git-latexdiff && make install && cd .. && rm -rf git-latexdiff

# Jekyll

RUN apt-get install -y ruby ruby-dev
RUN gem install bundler
RUN wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/source/Gemfile
RUN wget https://raw.githubusercontent.com/hoanganhduc/hoanganhduc.github.io/source/Gemfile.lock
RUN bundle install
RUN rm -rf Gemfile Gemfile.lock

# Remove more unnecessary stuff
RUN apt-get --purge remove -y .\*-doc$
RUN apt-get clean -y

