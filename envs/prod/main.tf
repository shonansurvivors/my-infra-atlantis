module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"
  version = "~> 3.0"

  name = "atlantis"

  # VPC
  vpc_id             = data.aws_vpc.main.id
  private_subnet_ids = data.aws_subnet.private.*.id
  public_subnet_ids  = data.aws_subnet.public.*.id

  # DNS (without trailing dot)
  route53_zone_name = var.atlantis_route53_zone_name

  # ACM (SSL certificate) - Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS
  certificate_arn = data.aws_acm_certificate.this.arn

  # ECS
  ecs_fargate_spot = true
  policies_arn = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    aws_iam_policy.ecs_ssmmessages.arn
  ]

  # Atlantis
  atlantis_github_user       = "shonansurvivors"
  atlantis_github_user_token = var.atlantis_github_user_token
  atlantis_repo_allowlist    = ["github.com/shonansurvivors/infra"]
  custom_environment_variables = [
    {
      "name" : "ATLANTIS_REPO_CONFIG_JSON",
      "value" : jsonencode(yamldecode(file("${path.module}/config.yaml"))),
    },
  ]
}

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

locals {
  azs = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

data "aws_acm_certificate" "this" {
  domain = var.aws_acm_certificate_this_domain
}

resource "aws_iam_policy" "ecs_ssmmessages" {
  name        = "atlantis-ssmmessages"
  description = "Enable ECS Exec"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
