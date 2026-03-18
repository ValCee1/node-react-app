# Create an EC2 instance for the server
resource "aws_instance" "app_server" {
  security_groups             = [aws_security_group.my-app.id]
  subnet_id                   = aws_subnet.my-app.id
  ami                         = var.ami
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  key_name                    = aws_key_pair.my-app.key_name
  user_data_replace_on_change = false

  user_data = templatefile("scripts/init.sh", {
    env    = var.env
    bucket = aws_s3_bucket.backup.bucket
  })

  tags = {
    Name = "${var.env}-${var.app_name}-server"
  }
  lifecycle {
    ignore_changes = [
      user_data,       # ignore user_data drift
      ami,             # ignore AMI updates (e.g. if you update AMIs externally)
      tags,            # ignore tag changes made outside Terraform
      security_groups, # legacy EC2-Classic attribute, ignore it
      # vpc_security_group_ids,
    ]
  }
  depends_on = [aws_iam_instance_profile.ec2_profile, aws_subnet.my-app, aws_key_pair.my-app]
}
