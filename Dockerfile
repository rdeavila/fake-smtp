FROM phusion/baseimage:0.10.0

RUN DEBIAN_FRONTEND=noninteractive \
    apt-key adv --fetch-keys http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_16.04/Release.key && \
    add-apt-repository 'deb "http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_16.04" ./' && \
    apt-get -y -q update && \
    apt-get -y -q install -o Dpkg::Options::="--force-confnew" \
        libivykis0 \
        jq \
        mailutils \
        syslog-ng-core \
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
