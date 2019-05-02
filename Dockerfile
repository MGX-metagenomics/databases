
FROM sjaenick/mgx:latest

LABEL version="1.0"
LABEL maintainer="sebastian@jaenicke.org"

COPY . /tmp/databases

# build dependencies
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install \
    rsync wget unzip libwww-perl

RUN cd /tmp/databases && for f in `cat build_order`; do \
       bash -x ${f}.build || exit 1; \
    done

RUN rm -rf /tmp/databases /root/.wget-hsts

#USER mgxserv
