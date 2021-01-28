provider "aws" {
    profile = "default"
    region = "eu-west-0"
}

resource "aws_s3_bucket" "tf_course" {
    bucket = "tf-course-20210128"
    acl = "private"
}