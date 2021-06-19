variable vpc_security_group_ids {
  type = "list"
}

variable iam_instance_profile {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  default     = ""
}

variable instance_type {
  default = "t2.medium" # 2 CPU, 4G Memory
}

variable subnet_id {}

variable ami {}
variable key_name {}

variable "user" {
  default = "aws-user"
}

variable user_data {
  description = "The user data to provide when launching the instance."
  default     = ""
}

variable private_ip {
  description = "Fixed ip address to assign the node instance, auto-assigned when not defined"
  default     = ""
}
