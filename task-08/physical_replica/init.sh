#!/bin/bash
set -e

rm -rf /var/lib/postgresql/data/*
pg_basebackup -p 5432 -h master -R -D /var/lib/postgresql/data/ -U postgres -W
