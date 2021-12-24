variable "atlantis_github_user_token" {
  type = string
}

variable "atlantis_route53_zone_name" {
  type = string
}

variable "aws_acm_certificate_this_domain" {
  type = string
}

variable "allow_ip_ranges" {
  type    = list(string)
  default = []
}
