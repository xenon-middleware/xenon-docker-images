FROM nlesc/xenon-alpine-base
MAINTAINER Stefan Verhoeven "s.verhoeven@esciencecenter.nl"

RUN apk add --no-cache apache2-webdav apache2-utils curl && \
htpasswd -bc /var/www/users.htpasswd xenon javagat && \
mkdir /run/apache2 && \

# make directory for DavLockDB (see ./httpd.conf)
mkdir /var/www/var && \
chown apache.apache /var/www/var && \

# make xenon user writable directory
mkdir /home/xenon/uploads && \
chown apache.apache /home/xenon/uploads && \

# make anonymous user writable directory
mkdir /var/www/uploads && \
cp -r /home/xenon/filesystem-test-fixture /var/www/uploads/ && \
chown apache.apache /var/www/uploads && \

# make anonymous user readable directory
mkdir /var/www/localhost/htdocs/downloads && \
cp -r /home/xenon/filesystem-test-fixture /var/www/localhost/htdocs/downloads/

ADD httpd.conf /etc/apache2/httpd.conf

EXPOSE 80
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]

HEALTHCHECK --interval=1s CMD curl -f http://localhost/ || exit 1
