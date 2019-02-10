FROM alpine:3.9
LABEL maintainer="alexandre.degurse@gmail.com"
ARG OPENDMARC_VERSION=1.3.2

RUN adduser -DHs /bin/false opendmarc

COPY opendmarc.conf /etc/opendmarc/opendmarc.conf

# build opendmarc
RUN apk add --update --no-cache --virtual .build-deps\
      curl tar gzip libspf2-dev libmilter-dev build-base gcc abuild binutils cmake &&\
    apk add --no-cache libspf2 libbsd libidn libmilter &&\
    curl -sSLO https://downloads.sourceforge.net/project/opendmarc/opendmarc-${OPENDMARC_VERSION}.tar.gz &&\
    tar -xf opendmarc-${OPENDMARC_VERSION}.tar.gz && rm opendmarc-${OPENDMARC_VERSION}.tar.gz &&\
    cd opendmarc-${OPENDMARC_VERSION} &&\
    ./configure --prefix=/usr \
      --bindir=/usr/bin \
      --sbindir=/usr/bin \
      --sysconfdir="/etc/opendmarc" \
      --with-spf \
      --with-spf2-include=/usr/include/spf2 \
      --with-spf2-lib=/usr/lib/ &&\
    # fix missing NETDB_INTERNAL definition
    sed -i '36i#define NETDB_INTERNAL -1' /usr/include/netdb.h &&\
    make && make -k check && make install &&\
    cd .. && rm -Rf opendmarc-$OPENDMARC_VERSION &&\
    apk del .build-deps

VOLUME ["/var/run/opendmarc"]

EXPOSE 8893

CMD ["/usr/bin/opendmarc", "-c", "/etc/opendmarc/opendmarc.conf"]
