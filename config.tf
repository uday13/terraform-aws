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


module "test-instance" {
  source = 
  subnet_id              = "${data.aws_subnet.az_a.id}"
  ami                    = "${var.ami_us-east["oel-7.9_2021_06"]}"
  key_name               = "${var.key_name}"
  tag_environment        = "${var.tag_environment}"
  tag_production         = "n"
  user_data              = "${var.user_data}"
  instance_key_file      = "${var.instance_key_file}"
  private_ip             = ""
}
  
resource "aws_sns_topic" "test" {
  name = "test-topic"
}

resource "aws_sqs_queue" "test_queue" {
  name = "test-queue"
}

resource "aws_sns_topic_subscription" "test_sqs_target" {
  topic_arn = aws_sns_topic.test.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.test_queue.arn
}
