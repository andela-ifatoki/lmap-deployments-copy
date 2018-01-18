#!/bin/bash

echo -e "ssh_command = ssh postgres@$1\nconninfo = host=$1 user=postgres" >> /etc/barman.conf
