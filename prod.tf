provider "aws" {
    profile = "default"
    region = "eu-central-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
    bucket = "tf-course-fg-20210128"
    acl = "private"
}

resource "aws_default_vpc" "default" {}