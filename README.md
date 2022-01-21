# my-infra-atlantis

## Manual plan/apply

```
brew install tfenv
```

```
cd envs/prod
```

```
cp terraform.tfvars.examle terraform.tfvars
```

```
saml2aws login -a prod
```

```
terraform init
terraform plan
terraform apply
```

## Ecs Exec

```
aws --profile prod ecs execute-command \
  --cluster atlantis \
  --container atlantis \
  --interactive \
  --command "/bin/bash" \
  --task task-id
```
