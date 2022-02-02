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
terraform plan -var atlantis_image_tag=$(git rev-parse --short HEAD)
terraform apply -var atlantis_image_tag=$(git rev-parse --short HEAD)
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
