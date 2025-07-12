provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.default.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  associate_public_ip_address = true

  tags = {
    Name = "patrick-ec2"
  }
}

resource "aws_eip" "ip" {}

resource "aws_eip_association" "assoc" {
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.ip.id
}
