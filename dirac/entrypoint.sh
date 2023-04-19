#!/bin/sh

mariadbd-safe &
/usr/sbin/sshd -De &
/opt/dirac/sbin/runsvdir-start
