  variable "whitelist" {
    type = list(string)
  }
  variable "web_image_id" {
    type = string
  }
  variable "web_instance_type" {
    type = string
  }
  variable "web_desired_capacity" {
    type = number
  }
  variable "web_max_size" {
    type = number
  }
  variable "web_min_size" {
    type = number
  }

provider "aws" {
    profile = "default"
    region = "eu-central-1"
}
resource "aws_s3_bucket" "prod_tf_course" {
    bucket = "tf-course-fg-20210128"
    acl = "private"
}

resource "aws_default_vpc" "default" { }

resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-central-1a"
  tags = {
    "Terraform" = "true"
  }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-central-1b"
  tags = {
    "Terraform" = "true"
  }
}

resource "aws_security_group" "prod_web" {
  name = "prod-web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress = [ {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
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
    cidr_blocks = var.whitelist
    description = "Allow incoming traffic from port 443 from any IP"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    self = false
    security_groups = []
  }]

    egress = [ {
      cidr_blocks = var.whitelist
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

module "web_app" {
  source           = "./modules/web_app"
  
  ami              = var.web_image_id
  instance_type    = var.web_instance_type
  desired_capacity = var.web_desired_capacity
  max_size         = var.web_max_size
  min_size         = var.web_min_size
  subnets          = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups  = [aws_security_group.prod_web.id]
  app_name         = "web"
}