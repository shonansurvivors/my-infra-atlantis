# my-infra-atlantis

## Manual plan/apply

```
brew install tfenv
```

```
cd envs/prod
```

```
tfenv use
```

```
cp terraform.tfvars.examle terraform
```

```
saml2aws login -a prod
```

```
terraform init
terraform plan
terraform apply
```
