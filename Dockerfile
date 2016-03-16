FROM ruby:slim
RUN apt-get update -qq && apt-get install -y git build-essential libpq-dev
RUN mkdir /app
WORKDIR /app
ADD . /app
RUN bundle install --clean --jobs 4
