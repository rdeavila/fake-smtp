FROM phusion/baseimage:0.9.22

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y -q update && \
    apt-get -y -q install \
        jq \
        mailutils \
        syslog-ng-mod-amqp && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY conf/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
COPY conf/main.cf /etc/postfix/main.cf
COPY conf/master.cf /etc/postfix/master.cf
COPY conf/rc.local /etc/rc.local
RUN mkdir -p /output && \
    echo "fakesmtp" > /etc/mailname && \
    chown nobody:nogroup /output && \
    chmod a+x /etc/rc.local

ENTRYPOINT ["/sbin/my_init", "--quiet", "--"]
