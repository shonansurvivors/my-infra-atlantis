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

  # ALB
  alb_ingress_cidr_blocks = flatten([
    data.github_ip_ranges.this.hooks_ipv4,
    var.allow_ip_ranges,
  ])

  # ECS
  atlantis_image   = aws_ecr_repository.atlantis.repository_url
  ecs_fargate_spot = true
  custom_environment_secrets = [
    {
      name      = "AWS_ACCOUNT_ID_MASTER"
      valueFrom = aws_ssm_parameter.aws_account_id_master.name
    },
    {
      name      = "AWS_ACCOUNT_ID_DEV"
      valueFrom = aws_ssm_parameter.aws_account_id_dev.name
    },
  ]
  policies_arn = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    aws_iam_policy.ecs_ssmmessages.arn
  ]

  # Atlantis
  atlantis_github_user             = "shonansurvivors"
  atlantis_github_user_token       = var.atlantis_github_user_token
  atlantis_hide_prev_plan_comments = true
  atlantis_log_level               = "info"
  atlantis_repo_allowlist          = ["github.com/shonansurvivors/*"]
  custom_environment_variables = [
    {
      "name" : "ATLANTIS_REPO_CONFIG_JSON",
      "value" : jsonencode(yamldecode(file("${path.module}/config.yaml"))),
    },
  ]

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

resource "aws_ssm_parameter" "aws_account_id_master" {
  name  = "/atlantis/aws/account_id_master"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "aws_account_id_dev" {
  name  = "/atlantis/aws/account_id_dev"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ecr_repository" "atlantis" {
  name = "atlantis"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "atlantis" {
  repository = aws_ecr_repository.atlantis.name

  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 10,
          "description" : "Keep last 3 images",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "imageCountMoreThan",
            "countNumber" : 3
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}

resource "null_resource" "docker" {
  provisioner "local-exec" {
    command = "aws --profile prod ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.atlantis.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker build -t atlantis docker"
  }

  provisioner "local-exec" {
    command = "docker tag atlantis:latest ${aws_ecr_repository.atlantis.repository_url}:latest"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.atlantis.repository_url}:latest"
  }
}
