FROM ruby:2.4-alpine

LABEL maintainer="panda.e@example.com"
LABEL team="panda"

ENV APP_DIR=/opt/app_name

RUN apk update && \
      apk add --update ruby-dev build-base \
      libxml2-dev libxslt-dev pcre-dev libffi-dev \
      postgresql-dev

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Cache bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --quiet
