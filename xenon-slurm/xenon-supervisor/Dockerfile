FROM xenon-fixture

# become root
USER root

# install supervisor package, from pip as opposed to from the package repositories, see:
# https://stackoverflow.com/questions/10716159/nginx-and-supervisor-setup-in-ubuntu
RUN apt-get update && apt-get install -y python-pip
RUN pip install --upgrade pip && pip install supervisor==3.0b2

# make the directory that will hold all the services's configuration
RUN mkdir -p /etc/supervisor

# add the supervisor configuration from the Docker context to inside the container
ADD supervisor/supervisord.conf /etc/supervisord.conf

# make the logging directory for supervisor
RUN mkdir -p /var/log/supervisor
RUN chmod -R 777 /var/log/supervisor

# add the shell script that will initialize all other services
ADD start-services.sh /etc/start-services.sh
RUN chmod +x /etc/start-services.sh
CMD /etc/start-services.sh
