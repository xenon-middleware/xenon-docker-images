FROM lubuntu-slurm

# become root
USER root

# add the supervisor configuration from the Docker context to inside the container
ADD supervisord.conf /etc/supervisord.conf

# make the logging directory for supervisor
RUN mkdir -p /var/log/supervisor
RUN chmod -R 777 /var/log/supervisor

# FIXME which ports should I expose? 
EXPOSE 10389 22 6817 6818

# start supervisord with given configuration to avoid security violation message
CMD /usr/bin/supervisord -c /etc/supervisord.conf
