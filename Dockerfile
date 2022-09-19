
FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update \
  && apt-get install -y ca-certificates \
  wget \
  cron \
  git \
  libssl-dev \
  fonts-cantarell \
  xfonts-75dpi \
  xfonts-base \
  libjpeg62-turbo \
  libxrender1 \
  mariadb-client \
  python2-minimal \
  postgresql-client \
  python3-dev \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf
ENV WKHTMLTOPDF_VERSION=0.12.6-1
RUN if [ "$(uname -m)" = "aarch64" ]; then export ARCH=arm64; fi \
    && if [ "$(uname -m)" = "x86_64" ]; then export ARCH=amd64; fi \
    && downloaded_file=wkhtmltox_$WKHTMLTOPDF_VERSION.buster_${ARCH}.deb \
    && wget -q https://github.com/wkhtmltopdf/packaging/releases/download/$WKHTMLTOPDF_VERSION/$downloaded_file \
    && dpkg -i $downloaded_file \
    && rm $downloaded_file

# Install frappe-bench
RUN pip install --upgrade pip
RUN pip install frappe-bench

# Create frappe user
RUN groupadd -g 1000 frappe \
    && useradd --no-log-init -r -m -u 1000 -g 1000 -G sudo frappe \
    && echo "frappe ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER frappe
WORKDIR /home/frappe

# Install NVM and Node
RUN mkdir /var/tmp/.nvm
ENV NVM_DIR /var/tmp/.nvm
ENV NODE_VERSION=14.20.0
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Add node and npm to path
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install yarn
RUN npm install -g yarn


