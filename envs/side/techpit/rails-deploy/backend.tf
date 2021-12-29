terraform {
  backend "s3" {
    bucket  = "shonansurvivors-rails-deploy-tfstate"
    key     = "my-infra-atlantis/rails-deploy.tfstate"
    profile = "rails-deploy"
    region  = "ap-northeast-1"
  }
}
