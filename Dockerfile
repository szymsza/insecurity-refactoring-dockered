# REBUILD CONTAINER: run `docker build -t itsec .` from the current folder

# syntax=docker/dockerfile:1



# --- GENERAL
FROM alpine:3.15
ENV PATH="/usr/bin:${PATH}"
RUN apk add git zip unzip

# Install C compiler
RUN apk add g++ make



# --- INSTALL DEPENDENCIES
# Python
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Java
RUN apk --no-cache add openjdk11

# Maven
RUN apk add --no-cache maven bash

# PHP
RUN apk add --no-cache php7 php7-dev php7-tokenizer
RUN echo "extension=ast.so" >> /etc/php7/php.ini

# CURL
RUN apk add curl

# PHP-AST
RUN git clone https://github.com/nikic/php-ast
RUN cd php-ast && phpize && ./configure && make && make install

# Joern
ENV GRADLE_VERSION 4.10.2
RUN curl https://downloads.gradle.org/distributions/gradle-4.10.2-bin.zip > gradle.zip; \
    unzip gradle.zip; \
    rm gradle.zip; \
    apk update && apk add --no-cache libstdc++ && rm -rf /var/cache/apk/*
ENV PATH "$PATH:/gradle-4.10.2/bin/"

RUN apk add py3-distutils-extra py3-setuptools
RUN pip3 install graphviz
#RUN apk add libgraphviz-dev pkg-config



# --- GET PROJECT
RUN git clone https://github.com/fschuckert/insecurity-refactoring.git
RUN cd insecurity-refactoring && ./compile_all.sh
RUN cd insecurity-refactoring/InsecurityRefactoring && mvn package

# Create a simple script to run the tool
RUN cd insecurity-refactoring/InsecurityRefactoring && echo "sh ./run_insec.sh -g" > start.sh && chmod +x start.sh

# Install fonts
RUN apk add ttf-dejavu



# --- ENABLE GUI APPLICATIONS
# Important: Only programs run under `developer` account work with GUI (therefore no sudo)
RUN apk add sudo
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    #echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel && \
    adduser developer wheel && \
    adduser developer adm && \
    adduser developer root && \
    adduser developer bin && \
    #chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer && \
    chown ${uid}:${gid} -R /insecurity-refactoring

# Erase developer account password
RUN passwd -d developer

# Log in as developer
USER developer
ENV HOME /home/developer

# Open bash sessions in repo directory
RUN echo "cd insecurity-refactoring/InsecurityRefactoring" >> ~/.bashrc
