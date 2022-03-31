provider "aws" {
  region = "eu-central-1"

}

variable "subnet_id_1" {
  default = "subnet-0a78c6d20296821f0"
}
variable "subnet_id_2" {
  default = "subnet-0d11b53f0d98dc334"
}
variable "subnet_id_3" {
  default = "subnet-0409b155a454a6a3f"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_template" "foobar" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}

resource "aws_autoscaling_group" "bar" {
  name                = "MultiAZEC2-ASG"
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [var.subnet_id_1, var.subnet_id_2, var.subnet_id_3]

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }

    tags = [
    {
      key                 = "Name"
      value               = "MultiAZEC2"
      propagate_at_launch = true
    },
  ]
}
