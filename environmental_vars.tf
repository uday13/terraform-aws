variable "aws_region" {
  default = "us-east-1"
}

variable "ami_us-east" {
  type = "map"

  default = {
    oel-7.9_202106 = "ami-0263b1da39775563a"
  }
}

variable "subnet_vpc_mgmt" {
  type = "map"

  default = {
    us-east-2a = "subnet-26202d50"
    us-east-2b = "subnet-6eddc10a"
  }
}

variable "tag_environment" {
  default = "Development"
}

variable "key_name" {
  description = "AWS key name to use when creating new EC2 instances"
}

variable "instance_key_file" {
  description = "The key file location to use in provisioning operations."
}
