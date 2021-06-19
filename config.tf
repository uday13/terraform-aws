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

# 1. creating test instance 
module "test-instance" {
  subnet_id              = "${data.aws_subnet.az_a.id}"
  ami                    = "${var.ami_us-east["oel-7.9_2021_06"]}"
  key_name               = "${var.key_name}"
  tag_environment        = "${var.tag_environment}"
  tag_production         = "n"
  user_data              = "${var.user_data}"
  instance_key_file      = "${var.instance_key_file}"
  private_ip             = ""
}
 
# 2. crearting sns and sqs topic and subscribe  
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
  
# 3. create conditional ec2 instances 
 # If var.aws_ec2_region is true, the count parameter for instance_by_region resources will be set to 1, so one of each ec2 will be created per region. 
 # If var.aws_ec2_region is false, the count parameter for instance_by_region resources will be set to 0, so neither one will be created. 
 # This is the conditional logic per region!
  
 module "instance_by_region" {
  source = "../main"
  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  aws_ec2_region     =   false
}
  
