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
  
