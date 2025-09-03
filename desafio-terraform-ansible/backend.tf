terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    region         = "us-east-1"
    key            = "state/terraform.state"
    bucket         = "statebucket-lucca-test"
    #dynamodb_table = ""
  }
}