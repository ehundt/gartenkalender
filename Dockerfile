FROM ruby:2.7.2-slim AS build

ARG RAILS_ENV=development
ENV RAILS_ENV ${RAILS_ENV}
ENV app /gartenkalender

RUN apt-get update && apt full-upgrade -y \
  && apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential \
  curl \
  imagemagick \
  postgresql-client \
  ruby-dev \
  shared-mime-info \
  libpq-dev \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
  && apt-get update && apt-get install -qq -y --no-install-recommends \
  nodejs \
  yarn \
  && gem install bundler:1.17.3 \
  && apt-get clean \
  && mkdir -p $app

WORKDIR $app

# Gems
COPY Gemfile Gemfile.lock ./

RUN bundle install

# Asset precompilation
COPY . ./
