FROM ruby:2.4.0-slim

WORKDIR /app

ENV BUNDLE_HOME="/app/bundle" \
    BUNDLER_VERSION="2.0.2" \
    LANG="C.UTF-8" \
    NODE_VERSION="10.16.3" \
    PATH="${PATH}:/root/.yarn/bin" \
    YARN_VERSION="1.17.3"

COPY ./pdftohtml /usr/local/bin/pdftohtml

# Install the absolute essentials
RUN apt-get update \
      && apt-get install -qq -y --no-install-recommends \
           awscli \
           apt-utils \
           build-essential \
           curl \
           git \
           imagemagick \
           libfontconfig \
           libnss3 \
           libpng-dev \
           libpq-dev \
           openssh-client \
           postgresql-client \
           zlib1g-dev \
      && rm -rf /var/lib/apt/lists/*

# Install node/npm from pre-built binary
RUN curl https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
      | tar xzf - \
          --exclude CHANGELOG.md \
          --exclude LICENSE \
          --exclude README.md \
          --strip-components 1 \
          -C /usr/local/

# Install yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version "$YARN_VERSION"

# Install and configure bundler
RUN echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
      && gem install bundler -v "$BUNDLER_VERSION" \
      && bundle config --global jobs 3
