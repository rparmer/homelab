#!/usr/bin/env bash

# remove old backups
find /volume1/k3s_backup/*.tar.gz -mtime +5 -exec rm {} \;

# create new backup
cd /volume1/k3s
tar -czf /volume1/k3s_backup/$(date +%Y%m%d%H%M%S).tar.gz .
