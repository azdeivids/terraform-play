terraform {
  required_providers {
    aws = {
        source = [hashicorp/aws]
        versversion = ">= 4.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias = "region_1"
}
provider "aws" {
  region = "us-west-1"
  alias = "region_2"
}