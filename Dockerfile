FROM ruby:2.6.3

RUN sed -i \
            -e 's|^# deb http://snapshot.debian.org|deb http://snapshot.debian.org|' \
            -e 's|^deb http://deb.debian.org|# deb http://deb.debian.org|' \
            -e 's|^deb http://security.debian.org|# deb http://security.debian.org|' \
            /etc/apt/sources.list \
        && apt-get -o Acquire::Check-Valid-Until=false update -qq \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV PROJECT_PATH /data/apps/changelogger
RUN mkdir -p $PROJECT_PATH

WORKDIR /data/apps/changelogger

ADD ./changelogger ./

EXPOSE 3000

COPY script/entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
