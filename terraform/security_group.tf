# Create a security group for the EC2 instance
resource "aws_security_group" "my-app" {
  vpc_id      = aws_vpc.my-app.id
  name        = "${var.env}-${var.app-name}"
  description = "Allow PING and SSH access and open port 3000"
  tags = {
    Name = "${var.env}-${var.app-name}"
  }
  egress {
    from_port   = -0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ALL_IP]
  }
  ingress {
    from_port   = var.SSH_PORT
    to_port     = var.SSH_PORT
    protocol    = "tcp"
    cidr_blocks = var.SSH_IPS
    description = "Allow SSH Access"
  }
  ingress {
    from_port   = "8"
    to_port     = "0"
    protocol    = "icmp"
    cidr_blocks = var.SSH_IPS
    description = "Allow PING Requests"
  }
  depends_on = [aws_vpc.my-app]
}

# Dynamically create security group rules for each port in the OPEN_PORTS variable
resource "aws_security_group_rule" "my-app" {
  for_each = toset(var.OPEN_PORTS)

  type              = "ingress"
  to_port           = each.value
  from_port         = each.value
  protocol          = "tcp"
  cidr_blocks       = [var.ALL_IP]
  security_group_id = aws_security_group.my-app.id
  depends_on        = [aws_security_group.my-app]
}
