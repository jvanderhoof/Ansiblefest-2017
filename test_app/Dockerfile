FROM ubuntu:16.04

MAINTAINER Jason Vanderhoof <jason.vanderhoof@cyberark.com>

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:brightbox/ruby-ng && \
    apt-get update -y

RUN apt-get install -y ruby2.4 ruby2.4-dev python

RUN gem install bundler --no-rdoc --no-ri

RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY Gemfile /opt/app/
COPY Gemfile.lock /opt/app/
RUN bundle install

COPY . /opt/app
