#!/bin/sh

exec /usr/bin/supervisord >> /var/log/supervisor/supervisord.log 2>&1
