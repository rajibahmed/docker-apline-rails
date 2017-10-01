FROM ruby:2.4-alpine

LABEL team="panda"

ENV APP_DIR=/opt/app_name

ENV BUILD_PACKAGES="ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev postgresql-dev " \
    RUBY_PACKAGES="ruby ruby-io-console ruby-json yaml "

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler

RUN \
  apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
  gem install -N bundler

RUN echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  # cleanup and settings
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Cache bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install
