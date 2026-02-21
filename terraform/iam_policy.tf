# Create an IAM role for EC2 to access S3
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Read and Write policy to the role to allow S3 access
resource "aws_iam_role_policy" "s3_write_policy" {
  name = "ec2-s3-write"
  role = aws_iam_role.ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
      }
    ]
  })
}

# Create an instance profile to attach the IAM role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-backup-profile"
  role = aws_iam_role.ec2_s3_role.name
}

