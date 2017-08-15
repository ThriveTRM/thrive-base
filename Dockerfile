FROM ruby:2.4.0-slim

WORKDIR /app

ENV NODE_VERSION="7.10.0" \
    BUNDLER_VERSION="1.15.0" \
    BUNDLE_HOME="/app/bundle" \
    YARN_VERSION="0.24.5" \
    PATH="${PATH}:/root/.yarn/bin"

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

RUN curl -L "ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.04.tar.gz" | tar xzvf - \
      && curl -L "http://sourceforge.net/projects/pdftohtml/files/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz" | tar xzvf - \
      && ( \
        cd xpdf-3.04 \
          && ./configure \
          && make \
          && cd ../pdftohtml-0.40a \
          && make \
          && rm -rf xpdf doc \
          && cp -r ../xpdf-3.04/xpdf ../xpdf-3.04/doc . \
          && make install \
          && mv src/pdftohtml /usr/local/bin \
      ) \
      && rm -rf pdftohtml-0.40a xpdf-3.04

# Install yarn
RUN curl -o- -L https://yarnpkg.com/install.sh \
      | bash -s -- --version "$YARN_VERSION"

# Install and configure bundler
RUN echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
      && gem install bundler -v "$BUNDLER_VERSION" \
      && bundle config --global jobs 3
