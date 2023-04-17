#!/bin/sh

mariadbd-safe &
/opt/dirac/sbin/runsvdir-start
