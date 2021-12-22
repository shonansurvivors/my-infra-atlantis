terraform {
  backend "s3" {
    bucket  = "shonansurvivors-prod-tfstate"
    key     = "my-infra-atlantis/prod.tfstate"
    profile = "prod"
    region  = "ap-northeast-1"
  }
}
