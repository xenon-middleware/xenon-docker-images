#!/bin/sh

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

# Initialize ssh agent
eval `setuser xenon ssh-agent`
setuser xenon /bin/ssh-fillpass-xenon
setuser xenon ssh-add -l

setuser xenon "$@"
