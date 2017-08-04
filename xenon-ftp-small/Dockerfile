FROM gliderlabs/alpine:3.1

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
#  && echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf \
#  && echo "passwd_chroot_enable=yes" >> /etc/vsftpd/vsftpd.conf \
#  && echo "background=NO" >> /etc/vsftpd/vsftpd.conf \
#  && echo "ftpd_banner=Welcome to FTP Server" >> /etc/vsftpd/vsftpd.conf \
#  && echo "local_umask=022" >> /etc/vsftpd/vsftpd.conf \
#  && echo "listen_ipv6=NO" >> /etc/vsftpd/vsftpd.conf \
#  && echo "chroot_local_user=YES" >> /etc/vsftpd/vsftpd.conf \
#  && sed -i "s/anonymous_enable=YES/anonymous_enable=NO/" /etc/vsftpd/vsftpd.conf

# Add the user
RUN addgroup -g 433 -S $FTP_USER && adduser -u 431 -D -G $FTP_USER -h /home/$FTP_USER -s /bin/false $FTP_USER
RUN echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd
RUN mkdir -p /var/run/vsftpd/empty

# Create the fixtures we need for testing in /home/$FTP_USER
RUN cd /home/$FTP_USER && \
mkdir -p filesystem-test-fixture/links && \
echo "Hello World" > filesystem-test-fixture/links/file0 && \
touch filesystem-test-fixture/links/file1 && \
ln -s /home/$FTP_USER/filesystem-test-fixture/links/file0 /home/$FTP_USER/filesystem-test-fixture/links/link0 && \
ln -s /home/$FTP_USER/filesystem-test-fixture/links/file1 /home/$FTP_USER/filesystem-test-fixture/links/link1 && \
ln -s /home/$FTP_USER/filesystem-test-fixture/links/file2 /home/$FTP_USER/filesystem-test-fixture/links/link2 && \
ln -s /home/$FTP_USER/filesystem-test-fixture/links/link0 /home/$FTP_USER/filesystem-test-fixture/links/link3 && \
ln -s /home/$FTP_USER/filesystem-test-fixture/links/link2 /home/$FTP_USER/filesystem-test-fixture/links/link4 && \
ln -s /home/$FTP_USER/filesystem-test-fixture/links/link6 /home/$FTP_USER/filesystem-test-fixture/links/link5 && \
ln -s /home/$FTP_USER/filesystem-test-fixture/links/link5 /home/$FTP_USER/filesystem-test-fixture/links/link6 && \
chown $FTP_USER:$FTP_USER /home/$FTP_USER/ -R

# Copy the startup script and make it executable.
COPY vsftpd.sh /usr/sbin/
RUN chmod +x /usr/sbin/vsftpd.sh

# Expose the needed ports, 21 for FTP, 21100-21110 for the passive data connections.
EXPOSE 21 3000-3100

# Start the FTP server.
CMD /usr/sbin/vsftpd.sh

HEALTHCHECK --interval=1s CMD curl -f ftp://localhost/ || exit 1

