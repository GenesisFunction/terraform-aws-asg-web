terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      version = ">= 3.63"
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.0"
    }
  }
}
