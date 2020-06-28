FROM ruby:2.7.1
ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev unzip libldap2-dev libidn11-dev fonts-migmix libjemalloc-dev imagemagick sudo

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

# Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && sh -c 'echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list' \
    && apt-get update -qq && apt-get install -y yarn

# add sudo user
RUN groupadd -g 1000 rails && \
    useradd  -g      rails -G sudo -m -s /bin/bash rails && \
    echo 'rails:rails' | chpasswd

RUN echo 'Defaults visiblepw'             >> /etc/sudoers
RUN echo 'rails ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER rails

WORKDIR /app
COPY entrypoint.sh /usr/bin
RUN sudo chmod +x /usr/bin/entrypoint.sh
RUN sudo chown -R rails:rails .
ADD package.json /app/package.json
ADD yarn.lock /app/yarn.lock
RUN yarn install
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --jobs 4
ADD . /app

RUN sudo apt-get autoremove -y \
    && sudo apt-get clean -y \
    && sudo rm -rf /var/lib/apt/lists/*


ENTRYPOINT [ "entrypoint.sh" ]
