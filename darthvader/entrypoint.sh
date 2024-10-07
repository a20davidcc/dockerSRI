#!/bin/bash

sed -i 's/^module(load="imklog")/#module(load="imklog")/' /etc/rsyslog.conf

rsyslogd

/etc/init.d/named start

tail -f /var/log/syslog
