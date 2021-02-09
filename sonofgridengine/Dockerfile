# Used https://github.com/gawbul/docker-sge as inspiration/source
FROM xenonmiddleware/phusion-base-16
LABEL maintainer="Jason Maassen <j.maassen@esciencecenter.nl>"

ADD install_sge.sh /usr/local

RUN echo "Package: xserver-xorg*\nPin: release *\nPin-Priority: -1" >> /etc/apt/preferences && \
echo "Package: unity*\nPin: release *\nPin-Priority: -1" >> /etc/apt/preferences && \
echo "Package: gnome*\nPin: release *\nPin-Priority: -1" >> /etc/apt/preferences && \
echo "gridengine-master shared/gridenginemaster string $HOSTNAME" | debconf-set-selections && \
echo "postfix postfix/main_mailer_type  string 'No configuration'" | debconf-set-selections && \
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nano inotify-tools wget bsd-mailx csh

RUN /bin/bash /usr/local/install_sge.sh

# Expose sshd port
EXPOSE 22
# Expose ge qmaster
EXPOSE 6444
# Expose ge execd
EXPOSE 6445

# add init scripts for master and exec deamons
RUN mkdir -p /etc/my_init.d

COPY files/etc/environment /home/xenon/.ssh/environment
COPY files/etc/ssh/sshd_config /etc/ssh/sshd_config
COPY files/etc/bash.bashrc /etc/bash.bashrc

COPY files/etc/init.d/sgeexecd.xenoncluster /etc/init.d/sgeexecd.xenoncluster
COPY files/etc/init.d/sgemaster.xenoncluster /etc/init.d/sgemaster.xenoncluster
COPY files/etc/init.d/.depend.boot /etc/init.d/.depend.boot
COPY files/etc/init.d/.depend.boot /etc/init.d/.depend.start
COPY files/etc/init.d/.depend.boot /etc/init.d/.depend.stop
COPY files/etc/my_init.d/sonofgridengine.sh /etc/my_init.d/sonofgridengine.sh
COPY files/opt/sge/default /opt/sge/default

COPY files/queues /var/tmp/queues
COPY files/parallel_environments /var/tmp/parallel_environments

#RUN ln -sf /etc/init.d/sgemaster.xenoncluster /etc/rc0.d/K01sgemaster.xenoncluster
#RUN ln -sf /etc/init.d/sgeexecd.xenoncluster /etc/rc0.d/K01sgeexecd.xenoncluster

#RUN ln -sf /etc/init.d/sgemaster.xenoncluster /etc/rc1.d/K01sgemaster.xenoncluster
#RUN ln -sf /etc/init.d/sgeexecd.xenoncluster /etc/rc1.d/K01sgeexecd.xenoncluster

#RUN ln -sf /etc/init.d/sgemaster.xenoncluster /etc/rc5.d/S01sgemaster.xenoncluster
#RUN ln -sf /etc/init.d/sgeexecd.xenoncluster /etc/rc5.d/S01sgeexecd.xenoncluster

#RUN ln -sf /etc/init.d/sgemaster.xenoncluster /etc/rc6.d/K01sgemaster.xenoncluster
#RUN ln -sf /etc/init.d/sgeexecd.xenoncluster /etc/rc6.d/K01sgeexecd.xenoncluster

#RUN echo "export SGE_ROOT=/opt/sge" >> /home/xenon/.profile
#RUN echo "export PATH=$PATH:/opt/sge/bin/lx-amd64" >> /home/xenon/.profile

#RUN echo PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/sge/bin/lx-amd64" > /etc/environment
#RUN echo SGE_ROOT="/opt/sge" >> /etc/environment





# config
#ADD etc/gridengine /etc/gridengine/files
#WORKDIR /var/tmp
#RUN mkdir host_groups exec_hosts
# && \
# Ignore domains
#perl -pi -e 's/false/true/' /var/lib/gridengine/default/common/bootstrap && \
#echo $HOSTNAME > /var/lib/gridengine/default/common/act_qmaster && \
#RUN /etc/init.d/sgemaster.xenoncluster start && sleep 2 && \
# submit host
#qconf -as $HOSTNAME && \
# hosts for queues
#/bin/echo -e "group_name @allhosts\nhostlist $HOSTNAME" > host_groups/allhosts && \
#qconf -Ahgrp host_groups/allhosts && \
#qconf -Ap parallel_environments/bi && \
#qconf -Ap parallel_environments/fillup && \
#qconf -Ap parallel_environments/round && \
#qconf -Mp parallel_environments/smp && \
#qconf -Aq queues/default && \
#qconf -Aq queues/slow 
#qconf -Msconf scheduler && \
#qconf -Mconf configurations/global && \
#killall sge_qmaster

CMD ["/sbin/my_init"]

# Check that qmaster, execd and sshd deamons accept connections
#HEALTHCHECK --interval=1s CMD qping -info xenon-sonofge 6444 qmaster 1 && \
#qping -info xenon-sonofge 6445 execd 1 && \ 
#ssh -o NoHostAuthenticationForLocalhost=yes -i /home/xenon/.ssh/id_rsa xenon@localhost /bin/true || exit 1

HEALTHCHECK --interval=1s CMD ssh -o NoHostAuthenticationForLocalhost=yes -i /home/xenon/.ssh/id_rsa xenon@localhost /bin/true || exit 1
