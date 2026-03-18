# Creating an IAM policy for S3 backup permissions

resource "aws_iam_policy" "s3_backup_policy" {
  name = "${var.env}-s3-backup-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.backup.arn
      },
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.backup.arn}/*"
      }
    ]
  })
}


# Creating an ECR Pull Policy (Managed) for instances to pull images from ECR.  

resource "aws_iam_policy" "ecr_pull_policy" {
  name = "${var.env}-ecr-pull-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = aws_ecr_repository.backend.arn
        Resource = aws_ecr_repository.frontend.arn
      }
    ]
  })
}

# IAM role for EC2 to pull from ECR and have S3 access for backups
# IAM Role for EC2
# This is the trust relationship. It allows EC2 service to assume the role.

resource "aws_iam_role" "ec2_role" {
  name = "${var.env}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# Attach Both S3 Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_backup_policy.arn
}

# Attach ECR Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}

# Create an instance profile for the EC2 role for attachment to EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
