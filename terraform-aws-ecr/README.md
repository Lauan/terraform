# terraform-aws-ecr

## Requirements / Providers

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.47 |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name for tagging purposes (e.g. development, stage or production) | `string` | N/A | Yes |
| application | Name of the application this registry is part of | `string` | N/A | Yes |
| ecr_repositories | Map of values to be used as parameters for ECR repositories. Required values are: name, component, repository, tag_overriding and enable_scan | `map(object)` | N/A | Yes |

## Deployed Resources (# of instances)

- aws_ecr_repository (1 ~ n)
- aws_ecr_repository_policy (1 ~ n)
- aws_iam_user_policy (0 ~ n)

## Output Variables

| Name | Description |
|------|-------------|
| repository_urls | List of repositories and repository URLs |

## Usage Example

Under construction
