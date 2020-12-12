terraform {
  required_version = ">=0.13.5"
  required_providers {
    aws = {
      version = "~>3.18.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

