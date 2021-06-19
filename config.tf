terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region              = "${var.aws_region}"
  version             = "~> 1.35"
  allowed_account_ids = [""]    # AWS ACCOUNT ?
}

data "aws_subnet" "az_a" {
  id = "${var.subnet_vpc_mgmt["us-east-1a"]}"
}


module "bastion" {
  subnet_id              = "${data.aws_subnet.az_a.id}"
  ami                    = "${var.ami_us-east["oel-7.9_2021_06"]}"
  key_name               = "${var.key_name}"
  tag_environment        = "${var.tag_environment}"
  tag_production         = "n"
  user_data              = "${var.user_data}"
  instance_key_file      = "${var.instance_key_file}"
  private_ip             = ""
}
