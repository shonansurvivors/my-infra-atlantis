provider "aws" {
  profile = "dev"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "dev"
      ManagedBy = "my-infra-atlantis"
    }
  }
}
