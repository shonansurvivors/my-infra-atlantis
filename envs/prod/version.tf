terraform {
  required_version = "1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
