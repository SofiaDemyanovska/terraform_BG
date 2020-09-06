locals {
  # The default username for our AMI
  vm_user = "ec2-user"
}

data "aws_ami" "latest-amazon-server" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "puppet_theatre_back" {
  key_name   = var.key_name
  public_key = "${file(var.public_key_path)}"
  tags       = "${var.tags}"
}


#---------------------------------------------------------------
resource "aws_launch_configuration" "puppet_theatre_back" {
#  name            = "WebServer-Highly-Available-LC"
  name_prefix     = "WebServer-LC-"
  key_name        = var.key_name
  image_id        = data.aws_ami.latest-amazon-server.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.default.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "puppet_theatre_back" {
  name                 = "ASG-${aws_launch_configuration.puppet_theatre_back.name}"
  launch_configuration = aws_launch_configuration.puppet_theatre_back.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = ["${aws_subnet.default.id}"]

#  load_balancers       = [aws_elb.puppet_theatre_back.name]


  dynamic "tag" {
    for_each = {
      Name   = "Terraform Blue/Green (v${var.infrastructure_version})"
      Owner  = "Sofia Demyanovska"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

