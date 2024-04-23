#!/bin/bash

DEST_DIR="/home/csye6225"

mkdir -p $DEST_DIR

cat << EOF > $DEST_DIR/.env
NODE_ENV=PROD
POSTGRES_HOST=${db_host}
POSTGRES_PASSWORD=${db_password}
POSTGRES_USER=${db_username}
POSTGRES_DB_NAME=${db_name}
GCP_PROJECT_ID=${gce_project_id}
GCP_TOPIC_NAME=${gce_topic_name}
EOF

chmod 600 $DEST_DIR/.env
chown csye6225:csye6225 $DEST_DIR/.env

sudo systemctl restart webappd
