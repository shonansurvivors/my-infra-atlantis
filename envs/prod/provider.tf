provider "aws" {
  profile = "prod"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "prod"
      ManagedBy = "my-infra-atlantis"
    }
  }
}
