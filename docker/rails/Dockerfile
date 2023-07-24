FROM ruby:3.2.2

ENV RAILS_ENV=production

RUN apt-get update -qq && \
    apt-get install -y apt-utils \
    build-essential \
    libpq-dev \
    nodejs \
    default-mysql-client \
    && apt-get install -y nodejs yarn
RUN apt-get update -qq && \
    apt-get install -y nodejs npm && \
    npm install --global yarn
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install -j4
ADD . /app

RUN bundle exec rails assets:precompile

EXPOSE 3000