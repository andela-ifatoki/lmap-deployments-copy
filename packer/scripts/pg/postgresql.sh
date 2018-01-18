#!/bin/bash

echo "archive_command = 'rsync -a %p barman@$1:/var/lib/barman/main-lmap-db/incoming/%f'" >> /etc/postgresql/9.5/main/postgresql.conf
