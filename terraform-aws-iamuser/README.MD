# terraform-aws-iamuser

## Requirements / Providers

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.47 |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name for tagging purposes (e.g. development, stage or production) | `string` | N/A | Yes |
| application | Name of the application this user is part of | `string` | N/A | Yes |
| component | Name of the component this user is part of | `string` | N/A | Yes |
| repository | Name of the repository that uses this role | `string` | N/A | Yes |
| username | Name for the User | `string` | N/A | Yes |
| userpath | Path for the user to be created at. If the user is being created for a pipeline run, this value should be pipeline | `string` | N/A | Yes |
| awspolicies | List of AWS managed policies to be attached to the user. | `list(string)` | [] | No |
| policystatements | List of maps containing the name (`string`), policyactions (list) and policyresources (list) for each statement on the policy to be created | `map(objects)` | N/A | Yes |
| policyname | Name for the Policy | `string` | N/A | Yes |
| extra_tags | Map with extra tags to add to the user | map(`string`) | {} | No |

## Deployed Resources (# of instances)

- aws_iam_user (1)
- aws_iam_user_policy_attachment (1)
- aws_iam_user_policy (0 ~ n)

## Output Variables

| Name | Description |
|------|-------------|
user_arn | User ARN |

## Usage Example

Under construction
