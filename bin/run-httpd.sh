#!/bin/bash

rm -rf $APACHE_PID_FILE

# use pipe due to error in Docker 1.8
mkfifo -m 777 /tmp/logpipe
cat < /tmp/logpipe 1>&2 &
# OSE 3 runs the container in a random uid
export APACHE_RUN_USER=$(id -u)
# Use libmapuid to map ose generate uid for passenger to correct passwd entry
export LD_PRELOAD=/usr/local/lib/libmapuid.so


exec /usr/sbin/apachectl -DFOREGROUND 
