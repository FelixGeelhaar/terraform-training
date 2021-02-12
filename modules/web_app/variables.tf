 variable "ami" {
    type = string
  }
  variable "instance_type" {
    type = string
  }
  variable "desired_capacity" {
    type = number
  }
  variable "max_size" {
    type = number
  }
  variable "min_size" {
    type = number
  }
  variable "subnets" {
    type = list(string)
  }
  variable "security_groups" {
    type = list(string)
  }
  variable "app_name" {
    type = string
  }