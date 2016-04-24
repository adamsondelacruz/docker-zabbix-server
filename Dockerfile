FROM debian:8
MAINTAINER Werner Dijkerman <ikben@werner-dijkerman.nl>

ENV ZABBIX_VERSION=3.0.1

RUN sed 's/main/main non-free/g' -i /etc/apt/sources.list && \
    apt-get update && \
    BUILD_PACKAGES="gcc libsnmp-dev libcurl4-openssl-dev make autoconf automake autotools-dev" && \
    apt-get install -y ${BUILD_PACKAGES} mysql-client curl bash snmp-mibs-downloader openipmi openssl libxml2-dev libsnmp-base libmysqlclient-dev sudo libssh2-1-dev libopenipmi-dev libgnutls28-dev mysql-client && \
    curl -sSLo /tmp/zabbix-${ZABBIX_VERSION}.tar.gz http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/${ZABBIX_VERSION}/zabbix-${ZABBIX_VERSION}.tar.gz/download && \
    cd /tmp && \
    tar xzf zabbix-${ZABBIX_VERSION}.tar.gz && \
    cd zabbix-${ZABBIX_VERSION} && \
    ./configure \
      --sysconfdir=/etc/zabbix \
      --enable-server \
      --with-libxml2 \
      --with-net-snmp \
      --with-libcurl \
      --with-mysql \
      --with-openipmi \
      --with-ssh2 \
      --with-gnutls && \
    make install && \
    useradd zabbix && \
    apt-get remove --purge -y ${BUILD_PACKAGES} && \
    mkdir -p /opt/zabbix/database && \
    cp -p /tmp/zabbix-3.0.1/database/mysql/* /opt/zabbix/database && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

EXPOSE 10051
ADD zabbix-server.sh /bin/zabbix-server.sh
RUN chmod +x /bin/zabbix-server.sh

ENV SHELL /bin/bash

CMD ["/bin/zabbix-server.sh"]
