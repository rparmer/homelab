#!/usr/bin/env bash

# remove old backups
ls /volume1/k3s_backup/*.tar.gz | sort -r | tail -n +5 | xargs -I {} rm -- {}

# create new backup
cd /volume1/k3s
tar -czf /volume1/k3s_backup/$(date +%Y%m%d%H%M%S).tar.gz .
