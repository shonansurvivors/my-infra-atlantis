provider "aws" {
  profile = "rails-deploy"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "rails-deploy"
      ManagedBy = "my-infra-atlantis"
    }
  }
}
