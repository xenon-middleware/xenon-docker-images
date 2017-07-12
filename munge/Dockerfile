FROM ssh

# following steps from https://slurm.schedmd.com/quickstart_admin.html

# install MUNGE for authentication. See also here:
# https://github.com/dun/munge/blob/master/QUICKSTART
USER root
RUN apt-get update && apt-get install -y munge libmunge2 libmunge-dev

# A munge authentication key should have been generated at /etc/munge/munge.key
# during installation of munge. If not, you can create one with the create-munge-key program or
# by following one of the steps outlined at https://github.com/dun/munge/blob/master/QUICKSTART

# Apply the recommended permissions to each of the munge directories; create /var/run/munge because
# that doesn't get created during install for some reason.
# Additionally, munge requires certain ownership of its directories; these should have been
# applied during install.
RUN chmod 0700 /etc/munge && \
chmod 0711 /var/lib/munge && \
chmod 0700 /var/log/munge && \
mkdir /var/run/munge && \
chmod 0755 /var/run/munge && \
chmod 0400 /etc/munge/munge.key

# copy the munge configuration for supervisord to inside the docker container
RUN mkdir -p /home/xenon/supervisor
ADD supervisor/munged.conf /home/xenon/supervisor/munged.conf

# Note: starting the munge daemon as user munge is delegated to the 'supervisord' program, which should
# be initiated elsewhere (see supervisor container).

