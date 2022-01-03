FROM ruby:2.7.1

RUN mkdir -p /vortrics
WORKDIR /vortrics

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    apt-transport-https \
    nodejs \
    postgresql-client \
    sqlite3 \
    yarn

COPY . /vortrics
COPY Gemfile /vortrics/

RUN gem install bundler -v 2.0.2
RUN bundle config gems.kiso.io 136f39c9711eb11b159f
RUN bundle install
RUN bundle update --bundler
RUN yarn install --ignore-engines

COPY . /vortrics
COPY ./entrypoint.sh /vortrics
ENTRYPOINT ["/vortrics/entrypoint.sh"]



