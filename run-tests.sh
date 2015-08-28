#!/bin/sh

if [ $MYUID -ne $(id xenon -u) ]
then
echo "Changing uid of xenon user to MYUID=$MYUID"
usermod -u $MYUID xenon
chown -R $MYUID /home/xenon
else
echo "Uid of xenon user is already same as MYUID=$MYUID, not changing uid"
fi

# ssh in prepareIntegrationTest in build.gradle adds ecdsa key which it cant read
setuser xenon ssh-keyscan -t rsa xenon-ssh >> /home/xenon/.ssh/known_hosts

setuser xenon ./gradlew check -x test
