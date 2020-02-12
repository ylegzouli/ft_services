#!/bin/sh

/etc/init.d/sshd restart
nginx -g "daemon off;"
