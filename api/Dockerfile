FROM ruby:2.7-alpine

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache \
    bash build-base curl-dev git postgresql-dev \
    tzdata yaml-dev zlib-dev nodejs yarn

RUN mkdir /api
WORKDIR /api

COPY Gemfile Gemfile.lock ./

RUN gem install bundler

RUN bundle check || bundle install

COPY . .

RUN ["chmod", "+x", "docker-entrypoint.sh"]

