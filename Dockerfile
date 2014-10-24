## Tuleap All In One ##

## Re-use tuleap base for caching ##
FROM centos:centos5

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

RUN rpm -i http://mir01.syntis.net/epel/5/i386/epel-release-5-4.noarch.rpm

RUN yum install -y \
    openssh-server \
    php53 \
    php53-common \
    rsyslog \
    mysql-server \
    postfix \
    which \
    python26; \
    yum clean all

RUN echo "NETWORKING=yes" > /etc/sysconfig/network
ADD Tuleap.repo /etc/yum.repos.d/

RUN /sbin/service sshd start && yum install -y \
    sudo \
    tuleap-install \
    tuleap-core-subversion \
    tuleap-core-cvs \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-hudson \
    tuleap-theme-flamingparrot \
    tuleap-plugin-graphontrackers \
    tuleap-plugin-git \
    tuleap-customization-default \
    tuleap-documentation \
    yum clean all

RUN curl -O https://bootstrap.pypa.io/get-pip.py && python26 get-pip.py && pip2.6 install supervisor && rm -f get-pip.py

ADD supervisord.conf /etc/supervisord.conf

ADD . /root/app
WORKDIR /root/app

VOLUME [ "/data" ]

EXPOSE 22 80

CMD ["/root/app/run.sh"]
