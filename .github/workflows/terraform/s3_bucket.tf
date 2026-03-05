# Create an S3 bucket for backups
resource "aws_s3_bucket" "backup" {
  bucket        = "${var.env}-${var.app_name}-backup-bucket"
  force_destroy = true

  tags = {
    Name        = "${var.env}-${var.app_name}-backup-bucket"
    Environment = var.env
  }
}


#Block Public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning on the S3 bucket to prevent accidental overwrite or deletion of backups
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backup.id

  versioning_configuration {
    status = "Enabled"
  }
}
