variable "AWS_REGION" {
}

variable "app-name" {
  type    = string
  default = "node-react"
}
variable "availability_zone" {
  type = string
}

variable "ALL_IP" {
  default = "0.0.0.0/0"
}

variable "ami" {
  type = string
}
variable "env" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "OPEN_PORTS" {
  type = list(string)
}

variable "PATH_TO_PUBLIC_KEY" {
  type = string
}
variable "subnet_cidr" {
  type = list(string)
}

variable "SSH_IPS" {
  type = list(string)

}
variable "SSH_PORT" {
  type    = number
  default = 22
}

variable "vpc_cidr" {
  type = string
}
