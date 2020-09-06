#Variables wuth defaults
variable "aws_region" {
  description = "Aws region for the instance"
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Aws region for the instance"
  default     = "t2.micro"
}

variable "public_key_path" {
  description = "Aws region for the instance"
  default     = "~/.ssh/server.pub"
}

variable "key_name" {
  description = "Aws region for the instance"
  default     = "SD-key-terraform1"
}

variable "tags" {
  type = "map"
  default = {
    ita_group = "Lv-517"
  }
}

variable "infrastructure_version" {
  default = "1"
}
