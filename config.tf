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
  
# 3. create conditional ece instances
resource "aws_instance" "instance_us-east-1" {
  count = var.aws_region ? 1 : 0
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}
  
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}
  
  
