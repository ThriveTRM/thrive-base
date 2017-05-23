FROM ruby:2.4.0-slim

ENV NODE_VERSION="7.10.0"

# Install the absolute essentials
RUN apt-get update \
      && apt-get install -qq -y --no-install-recommends \
            git \
            build-essential \
            libpq-dev \
            libpng-dev \
            zlib1g-dev \
            libfontconfig \
            imagemagick \
            postgresql-client \
      && rm -rf /var/lib/apt/lists/*

# Install node/npm from pre-built binary
RUN curl https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
      | tar xzvf - \
          --exclude CHANGELOG.md \
          --exclude LICENSE \
          --exclude README.md \
          --strip-components 1 \
          -C /usr/local/

# Install yarn and bundler
RUN gem install bundler --no-ri --no-rdoc \
      && npm install --global yarn
