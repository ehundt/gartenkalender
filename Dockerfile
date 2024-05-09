FROM ruby:2.7

ARG RAILS_ENV=development
ENV RAILS_ENV ${RAILS_ENV}
ENV app /socialgardener

RUN apt-get update && apt-get upgrade -y \
&& apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential \
  postgresql-client \
  ruby-dev \
  nodejs \
  && gem update --system 3.4.22 \
  && gem install bundler -v 1.17.3 \
  && mkdir -p $app

  WORKDIR $app

# Gems
COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./

ENTRYPOINT ["./docker_entrypoint.sh"]

# CMD ["rails server -b 0.0.0.0"]
