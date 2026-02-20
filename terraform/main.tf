
resource "aws_vpc" "my-app" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-${var.app-name}"
  }
}
