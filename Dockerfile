FROM ghcr.io/hoanganhduc/texlive:latest

# Metadata for the image
LABEL org.opencontainers.image.title="Arch Linux Base Workspace"
LABEL org.opencontainers.image.source="https://github.com/hoanganhduc/docker-workspace"
LABEL org.opencontainers.image.description="A custom Arch Linux installation with packages I often use"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="Duc A. Hoang <anhduc.hoang1990@gmail.com>"

USER root

ARG USERNAME=hoanganhduc
ARG USERHOME=/home/$USERNAME
ARG USERID=1000
ARG USERGECOS='Duc A. Hoang'

RUN userdel -r vscode

RUN useradd \
	--create-home \
	--home-dir "$USERHOME" \
	--password "" \
	--uid "$USERID" \
	--comment "$USERGECOS" \
	--shell /bin/zsh \
	"$USERNAME" && \
	echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	
USER $USERNAME
WORKDIR $USERHOME
CMD [ "/bin/zsh" ]

RUN wget https://raw.githubusercontent.com/hoanganhduc/docker-texlive/refs/heads/master/.zshrc && \
	chmod 644 $USERHOME/.zshrc  	

# Update

RUN yay -Syy

# RVM

RUN curl -L get.rvm.io > rvm-install && \
	chmod a+x rvm-install && \
	./rvm-install && \
	echo "source $USERHOME/.rvm/scripts/rvm" >> $USERHOME/.zshrc

# pdf2htmlEX

RUN yay -S --needed --noconfirm pdf2htmlex-appimage && \
	echo "alias pdf2htmlex=\"pdf2htmlEX --appimage-extract-and-run\"" >> $USERHOME/.zshrc	

# IPE

RUN yay -S --noconfirm --needed ipe

# LaTeX2HTML

RUN git clone https://github.com:latex2html/latex2html.git && \
	cd latex2html && \
	./configure && \
	make && \
	sudo make install && \
	cd .. && \
	rm -rf latex2html

# LaTeXML

RUN git clone https://github.com/brucemiller/LaTeXML.git && \
	cd LaTeXML && \
	perl Makefile.PL && \
	make && \
	sudo make install && \
	cd .. && \
	rm -rf LaTeXML
	
# Remove more unnecessary stuff
RUN yes | yay -Scc


