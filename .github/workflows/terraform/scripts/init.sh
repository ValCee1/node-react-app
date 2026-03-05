#!/bin/bash
set -euo pipefail # exit on error, treat unset variables as error, and fail on pipeline errors

LOG_FILE="/var/log/startup-init.log"
CRON_FILE="/etc/cron.d/mongo-backup"
USER_HOME="/home/ubuntu"
BACKUP_SCRIPT_PATH="$USER_HOME/backup.sh"
ENV="${env}"      # injected by Terraform templatefile
BUCKET="${bucket}" # injected by Terraform templatefile

exec > >(tee -a "$LOG_FILE") 2>&1
echo "===== EC2 Initialization Started at $(date) ====="

apt update -y
apt install -y docker.io cron unzip curl

# Install AWS CLI v2
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Docker setup
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu
timeout 30 bash -c 'until docker info > /dev/null 2>&1; do sleep 1; done'

# Docker Compose
curl -fsSL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Dependencies installed"

cat << 'SCRIPT' > "$BACKUP_SCRIPT_PATH"
#!/bin/bash
set -euo pipefail

ENV="__ENV__"
BUCKET="__BUCKET__"
SERVICE="mongodb"
DATE=$(date +"%Y/%m/%d")
TIMESTAMP=$(date +"%F-%H-%M")
ARCHIVE="backup-$TIMESTAMP.archive.gz"
WORKDIR="/tmp/mongo-backups"

mkdir -p "$WORKDIR"
echo "Starting Mongo backup at $(date)..."

docker exec mongo mongodump --archive --gzip > "$WORKDIR/$ARCHIVE"
aws s3 cp "$WORKDIR/$ARCHIVE" "s3://$BUCKET/$ENV/$SERVICE/$DATE/$ARCHIVE"
rm -f "$WORKDIR/$ARCHIVE"

echo "Backup completed at $(date)."
SCRIPT

# Substitute env values into backup script
sed -i "s/__ENV__/$ENV/g; s/__BUCKET__/$BUCKET/g" "$BACKUP_SCRIPT_PATH"

# Set permissions for backup script
chmod +x "$BACKUP_SCRIPT_PATH"
chown ubuntu:ubuntu "$BACKUP_SCRIPT_PATH"

# Log rotation
echo "Setting up log rotation for Mongo backup logs..."
cat << 'EOF' > /etc/logrotate.d/mongo-backup
/var/log/mongo-backup.log 
  weekly
  rotate 4
  compress
  missingok
  notifempty

EOF

# Set up cron job for backup script
echo "Setting up cron job for Mongo backup..."
echo "0 2 * * * ubuntu $BACKUP_SCRIPT_PATH >> /var/log/mongo-backup.log 2>&1" > "$CRON_FILE"
chmod 644 "$CRON_FILE"

systemctl restart cron

echo "===== EC2 Initialization Completed at $(date) ====="