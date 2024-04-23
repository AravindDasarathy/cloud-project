#!/bin/bash

set -x

# create a no-login user and add to a group
sudo groupadd csye6225
sudo useradd csye6225 -g csye6225 --system --shell /sbin/nologin

# install nodejs
sudo dnf module enable nodejs:20 -y
sudo dnf install nodejs -y

# install google cloud ops agent
sudo curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo mv /tmp/logger-config.yaml /etc/google-cloud-ops-agent/config.yaml
sudo systemctl restart google-cloud-ops-agent

# create log directory with proper permissions
sudo mkdir -p /var/log/webapp
sudo chown csye6225:csye6225 /var/log/webapp

# install unzip
sudo dnf install unzip -y

# install webapp
sudo mkdir -p /home/csye6225
sudo chown csye6225:csye6225 /home/csye6225
cd /home/csye6225
sudo mv /tmp/webapp.zip .
sudo -u csye6225 unzip webapp.zip
sudo -u csye6225 npm install

# start webapp
sudo mv /tmp/webappd.service /etc/systemd/system/webappd.service
sudo systemctl daemon-reload
sudo systemctl enable webappd
sudo systemctl start webappd