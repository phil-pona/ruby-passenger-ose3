FROM openshift/ruby-22-centos7

USER root

RUN yum update -y && \
    yum -y install httpd httpd-devel apr-devel apr-util-devel \
                   ImageMagick-c++ ImageMagick-c++-devel transifex-client sqlite3 && \
    yum clean all -y

RUN /bin/bash -c "gem install passenger --no-ri --no-rdoc && \
    export PATH=$PATH:/opt/rh/rh-ruby22/root/usr/local/bin && \
    passenger-install-apache2-module --auto --languages ruby && \
    passenger-config validate-install "

ENV RAILS_ENV=production \
    RAILS_ROOT=/opt/app-root/src

# ADD app /opt/app-root/src
ADD app /tmp/src
ADD httpd /etc/httpd
ADD lib /usr/local/lib
# disable digest_module
RUN sed -i "s/LoadModule auth_digest_module/#LoadModule auth_digest_module/" /etc/httpd/conf.modules.d/00-base.conf

RUN mkdir -p /opt/app-root/httpd/logs && \
    mkdir -p /opt/app-root/httpd/pid

RUN chgrp -R 0 ./ && \
    chmod -R g+rw ./ && \
    find ./ -type d -exec chmod g+x {} + && \
    chown -R 1001:0 ./

RUN chmod -R a+rwX /opt/app-root/httpd/logs && \
    chmod -R a+rwX /opt/app-root/httpd/pid

USER 1001

RUN $STI_SCRIPTS_PATH/assemble
    

ENV APACHE_RUN_USER 1001 
ENV APACHE_PID_FILE /opt/app-root/httpd.pid 

CMD /usr/bin/env APACHE_RUN_USER=$(id -u) LD_PRELOAD=/usr/local/lib/libmapuid.so /usr/sbin/apachectl -DFOREGROUND 
