## Tuleap All In One ##

## Re-use tuleap base for caching ##
FROM centos:centos5

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

RUN rpm -i http://mir01.syntis.net/epel/5/i386/epel-release-5-4.noarch.rpm

RUN yum install -y mysql-server; yum clean all

RUN yum install -y openssh-server; yum clean all
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
RUN yum install -y php53 php53-common
ADD Tuleap.repo /etc/yum.repos.d/
ADD rpms /rpms
RUN yum install -y sudo; yum clean all

# RUN cd /rpms && /sbin/service sshd start && yum install -y --nogpgcheck *.rpm
RUN yum install -y tuleap-install; yum clean all
RUN yum install -y tuleap-core-subversion; yum clean all
RUN yum install -y tuleap-plugin-agiledashboard; yum clean all
RUN yum install -y tuleap-plugin-hudson; yum clean all
RUN yum install -y tuleap-theme-flamingparrot; yum clean all
RUN yum install -y tuleap-plugin-graphontrackers; yum clean all
RUN yum install -y tuleap-customization-default; yum clean all
RUN yum install -y tuleap-documentation; yum clean all
RUN yum install -y restler-api-explorer; yum clean all

RUN /sbin/service sshd start && yum install -y tuleap-plugin-git; yum clean all

RUN yum install -y rsyslog; yum clean all

ADD supervisord.conf /etc/supervisord.conf

ADD . /root/app
WORKDIR /root/app

VOLUME [ "/data" ]

EXPOSE 22 80

CMD ["/root/app/run.sh"]
