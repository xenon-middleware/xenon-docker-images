FROM slurm

# become root
USER root

# install supervisor package
RUN apt-get update && apt-get install -y supervisor

# add the supervisor configuration from the Docker context to inside the container
ADD supervisor/supervisord.conf /home/xenon/supervisor/supervisord.conf
ADD supervisor/supervisorctl.conf /home/xenon/supervisor/supervisorctl.conf

# copy the supervisor service configurations to a place where supervisor knows to look for it
RUN cp /home/xenon/supervisor/*.conf /etc/supervisor/conf.d/

# make the logging directory for supervisor
RUN mkdir -p /var/log/supervisor
RUN chmod -R 777 /var/log/supervisor

# FIXME which ports should I expose?
EXPOSE 10389 22 6817 6818

# start supervisord with given configuration to avoid security violation message
# CMD /usr/bin/supervisord -c /etc/supervisord.conf
