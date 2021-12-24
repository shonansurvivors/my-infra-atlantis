data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main"]
  }
}

data "aws_subnet" "public" {
  count  = length(local.azs)
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["main-public-${local.azs[count.index]}"]
  }
}

data "aws_subnet" "private" {
  count  = length(local.azs)
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["main-private-${local.azs[count.index]}"]
  }
}

data "aws_acm_certificate" "this" {
  domain = var.aws_acm_certificate_this_domain
}

data "github_ip_ranges" "this" {}
