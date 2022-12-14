terraform {
  required_providers {
    aws = {
      source      = [hashicorp / aws]
      versversion = ">= 4.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "region_1"
}
provider "aws" {
  region = "us-west-1"
  alias  = "region_2"
}
## look up ami for specific region
data "aws_ami" "ubuntu_region_1" {
  provider    = aws.region_1
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
data "aws_ami" "ubuntu_region_2" {
  provider    = aws.region_2
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
## deploy two EC2 instances in different region
resource "aws_instance" "region_1" {
  provider = aws.region_1

  ami           = data.aws_ami.ubuntu_region_1.id
  instance_type = "t2.micro"
}
resource "aws_instance" "region_2" {
  provider = aws.region_2

  ami           = data.aws_ami.ubuntu_region_2.id
  instance_type = "t2.micro"
}