#!/bin/bash
ssh-keygen -t rsa -b 4096 -f /app/deploy_key -N "" -C "deploy"
chmod 600 /app/deploy_key
chmod 644 /app/deploy_key.pub
mkdir -p /app/.ssh
cp /app/deploy_key.pub /app/.ssh/authorized_keys
chmod 600 /app/.ssh/authorized_keys
ssh-keygen -l -f /app/deploy_key.pub > /app/key_fingerprint.txt
