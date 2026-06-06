#!/bin/bash

ENDPOINT="https://2facaf145e3168f2454a53d1b79f94e5.r2.cloudflarestorage.com"
BUCKET="mongodb-backups"

# Find the latest backup tarball
LATEST=$(aws s3 ls s3://$BUCKET --endpoint-url $ENDPOINT \
  | sort | tail -n 1 | awk '{print $4}')

echo "Latest backup file: $LATEST"

# Download the latest backup
aws s3 cp s3://$BUCKET/$LATEST . --endpoint-url $ENDPOINT

# Extract the tarball
tar -xzf "$LATEST"

# Detect the extracted folder (first directory inside the tarball)
RESTORE_DIR=$(tar -tzf "$LATEST" | head -1 | cut -f1 -d"/")

echo "Restoring from directory: $RESTORE_DIR"

# Restore MongoDB from the extracted dump
mongorestore --drop "$RESTORE_DIR"
