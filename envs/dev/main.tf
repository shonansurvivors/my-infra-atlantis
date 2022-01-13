resource "aws_iam_role" "atlantis" {
  name  = "atlantis"

  assume_role_policy = data.aws_iam_policy_document.atlantis.source_json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

data "aws_iam_policy_document" "atlantis" {
  source_json = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${var.aws_account_id_prod}:role/atlantis-ecs_task_execution"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_db_instance" "test" {
  instance_class = "test"
}
