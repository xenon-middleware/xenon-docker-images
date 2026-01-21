#!/bin/sh

mariadbd-safe &
/usr/sbin/sshd -De &
su -c "/usr/sbin/myproxy-server" dirac
/opt/dirac/sbin/runsvdir-start
