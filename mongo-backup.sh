#!/bin/bash

DATE=$(date +"%Y-%m-%d-%H-%M")

BACKUP_DIR="/tmp/mongodb-backup-$DATE"
ARCHIVE="/tmp/mongodb-$DATE.tar.gz"

BUCKET_NAME="mongodb-backups"
ENDPOINT="https://2facaf145e3168f2454a53d1b79f94e5.r2.cloudflarestorage.com"

echo "Starting backup..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# MongoDB dump
mongodump --db companydb --out "$BACKUP_DIR"

# Compress backup
tar -czf "$ARCHIVE" -C "$BACKUP_DIR" .

# Upload to Cloudflare R2
aws s3 cp "$ARCHIVE" "s3://$BUCKET_NAME/mongodb-$DATE.tar.gz" \
  --endpoint-url "$ENDPOINT"

# Cleanup
rm -rf "$BACKUP_DIR"
rm -f "$ARCHIVE"

echo "Backup completed successfully"
