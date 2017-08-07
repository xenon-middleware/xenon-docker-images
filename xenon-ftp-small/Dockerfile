#FROM gliderlabs/alpine:3.1
FROM nlesc/xenon-alpine-base

# These are the basic settings used for FTP
ENV FTP_USER=xenon \
    FTP_PASS=javagat \
    PASV_ADDRESS=127.0.0.1 \
    PASV_MIN=3000 \
    PASV_MAX=3100

# Install vsftp
RUN apk update && apk upgrade && apk --update add vsftpd curl

# Create the config file
RUN echo "listen=YES" > /etc/vsftpd/vsftpd.conf \
  && echo "local_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "anonymous_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "anon_root=/srv/ftp" >> /etc/vsftpd/vsftpd.conf \
  && echo "write_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "dirmessage_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "use_localtime=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "xferlog_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "connect_from_port_20=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd/vsftpd.conf \
  && echo "syslog_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "seccomp_sandbox=NO" >> /etc/vsftpd/vsftpd.conf \
  && echo "pasv_enable=Yes" >> /etc/vsftpd/vsftpd.conf \
  && echo "pasv_max_port=$PASV_MAX" >> /etc/vsftpd/vsftpd.conf \
  && echo "pasv_min_port=$PASV_MIN" >> /etc/vsftpd/vsftpd.conf \
  && echo "pasv_address=$PASV_ADDRESS" >> /etc/vsftpd/vsftpd.conf

# Add the needed directories for anonymous
RUN mkdir -p /var/run/vsftpd/empty && mkdir -p /srv/ftp

# Create the fixtures we need for testing in /home/$FTP_USER
RUN cd /srv/ftp/ && \
mkdir -p filesystem-test-fixture/links && \
echo "Hello World" > filesystem-test-fixture/links/file0 && \
touch filesystem-test-fixture/links/file1 && \
ln -s /srv/ftp/filesystem-test-fixture/links/file0 /srv/ftp/filesystem-test-fixture/links/link0 && \
ln -s /srv/ftp/filesystem-test-fixture/links/file1 /srv/ftp/filesystem-test-fixture/links/link1 && \
ln -s /srv/ftp/filesystem-test-fixture/links/file2 /srv/ftp/filesystem-test-fixture/links/link2 && \
ln -s /srv/ftp/filesystem-test-fixture/links/link0 /srv/ftp/filesystem-test-fixture/links/link3 && \
ln -s /srv/ftp/filesystem-test-fixture/links/link2 /srv/ftp/filesystem-test-fixture/links/link4 && \
ln -s /srv/ftp/filesystem-test-fixture/links/link6 /srv/ftp/filesystem-test-fixture/links/link5 && \
ln -s /srv/ftp/filesystem-test-fixture/links/link5 /srv/ftp/filesystem-test-fixture/links/link6 && \
chown -R ftp.ftp /srv/ftp/filesystem-test-fixture

# Copy the startup script and make it executable.
ADD vsftpd.sh /usr/sbin/vsftpd.sh
RUN chmod +x /usr/sbin/vsftpd.sh

# Expose the needed ports, 21 for FTP, 21100-21110 for the passive data connections.
EXPOSE 21 3000-3100

# Start the FTP server.
CMD /usr/sbin/vsftpd.sh

HEALTHCHECK --interval=1s CMD curl -f ftp://localhost/ || exit 1

