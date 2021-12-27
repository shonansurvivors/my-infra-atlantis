terraform {
  backend "s3" {
    bucket  = "shonansurvivors-dev-tfstate"
    key     = "my-infra-atlantis/dev.tfstate"
    profile = "dev"
    region  = "ap-northeast-1"
  }
}
