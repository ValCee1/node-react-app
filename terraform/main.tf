resource "aws_vpc" "my-app" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-${var.app_name}"
  }
}

resource "aws_internet_gateway" "my-app" {
  vpc_id = aws_vpc.my-app.id
  tags = {
    Name = "${var.env}-${var.app_name}"
  }
  depends_on = [aws_vpc.my-app]
}

resource "aws_route_table" "my-app" {
  vpc_id = aws_vpc.my-app.id

  route {
    cidr_block = var.ALL_IP
    gateway_id = aws_internet_gateway.my-app.id
  }
  depends_on = [aws_vpc.my-app, aws_internet_gateway.my-app]
}

resource "aws_subnet" "my-app" {
  vpc_id                  = aws_vpc.my-app.id
  cidr_block              = var.subnet_cidr[0]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.app_name}"
  }
  depends_on = [aws_route_table.my-app]
}

resource "aws_route_table_association" "my-app" {
  subnet_id      = aws_subnet.my-app.id
  route_table_id = aws_route_table.my-app.id
  depends_on     = [aws_subnet.my-app]
}

# Create a key pair for SSH access from my computer
resource "aws_key_pair" "my-app" {
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  key_name   = "Macbook"
  tags = {
    Name = "${var.env}-${var.app_name}-key"
  }
}
