provider "aws" {
  profile = "master"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "master"
      ManagedBy = "my-infra-atlantis"
    }
  }
}
