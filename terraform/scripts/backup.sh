#!/bin/bash
# This script performs a backup of a MongoDB database and uploads it to an S3 bucket
set -e  # exit on error

ENV="dev"
APP_NAME="my-app"
SERVICE="mongodb"
BUCKET="$ENV-$APP_NAME-backup-bucket"

DATE=$(date +"%Y/%m/%d")
TIMESTAMP=$(date +"%F-%H-%M")

BACKUP_DIR="/tmp/mongo-$TIMESTAMP"
ARCHIVE="backup-$TIMESTAMP.tar.gz"

echo "Starting backup at $(date)"

mongodump --uri="$MONGO_URI" --out=$BACKUP_DIR

tar -czf $ARCHIVE $BACKUP_DIR

aws s3 cp $ARCHIVE s3://$BUCKET/$ENV/$SERVICE/$DATE/$ARCHIVE

echo "Backup uploaded successfully"

rm -rf $BACKUP_DIR $ARCHIVE

echo "Backup completed at $(date)"