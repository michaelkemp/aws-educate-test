terraform {
  required_version = ">=0.14.2"
  required_providers {
    aws = {
      version = "~>3.21.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

