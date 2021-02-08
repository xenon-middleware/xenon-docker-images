#!/bin/sh

# SonOfGE can not start in the foreground so use the rc scripts
/etc/init.d/sgemaster.xenoncluster start
/etc/init.d/sgeexecd.xenoncluster start

