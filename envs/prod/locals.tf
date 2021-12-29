locals {
  azs = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]

  aws_ssm_parameter = {
    aws_account_id = {
      master       = "dummy"
      dev          = "dummy"
      rails_deploy = "dummy"
    }
  }
}
