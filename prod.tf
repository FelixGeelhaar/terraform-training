provider "aws" {
    profile = "default"
    region = "eu-central-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
    bucket = "tf-course-fg-20210128"
    acl = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress = [ {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming traffic from port 80 from any IP"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    self = false
    security_groups = []
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming traffic from port 443 from any IP"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    self = false
    security_groups = []
  }]

    egress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Everything allowed as outbound traffic"
      from_port = 0
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "-1"
      security_groups = []
      self = false
      to_port = 0
    } ]

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_instance" "prod_web" {
  ami           = "ami-0a1273aaf0a904500"
  instance_type = "t2.nano"

  vpc_security_group_ids = [ aws_security_group.prod_web.id ]

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_eip" "prod_web" {
  instance = aws_instance.prod_web.id

  tags = {
    "Terraform" = "true"
  }
}

