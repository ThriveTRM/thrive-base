FROM ruby:2.4.0-slim

WORKDIR /app

ENV NODE_VERSION="7.10.0" \
    BUNDLER_VERSION="1.15.0" \
    BUNDLE_HOME="/app/bundle" \
    YARN_VERSION="0.24.5" \
    PATH="${PATH}:/root/.yarn/bin"

COPY ./pdftohtml /usr/local/bin/pdftohtml

# Install the absolute essentials
RUN apt-get update \
      && apt-get install -qq -y --no-install-recommends \
            git \
            curl \
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

# Install yarn
RUN curl -o- -L https://yarnpkg.com/install.sh \
      | bash -s -- --version "$YARN_VERSION"

# Install and configure bundler
RUN echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
      && gem install bundler -v "$BUNDLER_VERSION" \
      && bundle config --global jobs 3
