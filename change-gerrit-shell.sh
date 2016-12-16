#!/bin/sh

cp /etc/passwd /etc/passwd.bck
sed '/gerrit2/s/sbin\/nologin/bin\/sh/g' /etc/passwd.bck > /etc/passwd
