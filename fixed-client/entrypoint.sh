#!/bin/bash

# Testing if UID was empty (not allowed)
if [ "$MYUID" = "" ]; then
	echo "\$MYUID is not set"
	exit 1
elif [ "$MYUID" = "$(id xenon -u)" ]; then
	echo "Uid of xenon user is already same as MYUID=$MYUID, not changing uid"
else
	echo "Changing uid of xenon user to MYUID=$MYUID"
	usermod -u $MYUID xenon
	chown -R $MYUID /home/xenon
fi

MYDOCKERGID=`cut -d: -f3 < <(getent group docker)`

# Testing if DOCKERGID was empty (not allowed)
if [ "$DOCKERGID" = "" ]; then
	echo "\$DOCKERGID is not set"
	exit 1
elif [ "$DOCKERGID" = "$MYDOCKERGID" ]; then
	echo "Gid of docker group is already same as DOCKERGID=$DOCKERGID, not changing gid"
else
	echo "Changing gid of docker group to DOCKERGID=$DOCKERGID"
	groupmod -g $DOCKERGID docker
fi

# Initialize ssh agent
eval `setuser xenon ssh-agent`
setuser xenon /bin/ssh-fillpass-xenon
setuser xenon ssh-add -l

setuser xenon "$@"


