terraform {
  backend "s3" {
    bucket  = "shonansurvivors-master-tfstate"
    key     = "my-infra-atlantis/master.tfstate"
    profile = "master"
    region  = "ap-northeast-1"
  }
}
