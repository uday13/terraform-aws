resource "aws_instance" "test" {
  # subnet ID and availability zone for our VPC
  subnet_id = "${var.subnet_id}"

  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "false"

  vpc_security_group_ids = [
    "${var.vpc_security_group_ids}",
  ]

  # Lookup the correct AMI based on the region we specified
  ami = "${var.ami}"

  # The name of our SSH keypair you've created and downloaded from the AWS console.
  key_name = "${var.key_name}"

  private_ip = "${var.private_ip}"

  user_data = "${var.user_data}"

  connection {
    user        = "${var.user}"
    private_key = "${file("${var.instance_key_file}")}"
  }
  
# both resources can be written as part of a module (example name: instance_by_region)
resource "aws_instance" "instance_us-east-1" {
  region = var.aws_ec2_region ? 1 : 0
  
  subnet_id              = "${data.aws_subnet.az_a.id}"
  ami                    = "${var.ami_us-east["oel-7.9_2021_06"]}"
  key_name               = "${var.key_name}"
  tag_environment        = "${var.tag_environment}"
  user_data              = "${var.user_data}"
  instance_key_file      = "${var.instance_key_file}"
  private_ip             = ""
}
  
resource "aws_instance" "instance_eu-central-1" {
  region = var.aws_ec2_region ? 1 : 0
  
  subnet_id              = "${data.aws_subnet.az_a.id}"
  ami                    = "${var.ami_eu-central["oel-7.9_2021_06"]}"
  key_name               = "${var.key_name}"
  tag_environment        = "${var.tag_environment}"
  user_data              = "${var.user_data}"
  instance_key_file      = "${var.instance_key_file}"
  private_ip             = ""
}
