# terraform-aws-iamrole

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
| rolename | Name for the Role | `string` | N/A | Yes |
| rolepath | Path for the role to be created at. If the user is being created for a pipeline run, this value should be pipeline | `string` | N/A | Yes |
| roledescription | A brief description about the role to be created |
| service_principal | Service principal that will assume this role (ex: lambda.amazonaws.com) | `list(string)` | N/A | Yes |
| managed_policy_arns | List of AWS Managed Policies to attach to this role.  | `list(string)` | [] | No |
| policystatements | List of maps containing the name (`string`), policyactions (list) and policyresources (list) for each statement on the policy to be created | `map(objects)` | N/A | Yes |
| policyname | Name for the Policy | `string` | N/A | Yes |

## Deployed Resources (# of instances)

- aws_iam_role (1)
- aws_iam_role_policy (1)

## Output Variables

| Name | Description |
|------|-------------|
| role_arn | Role ARN |

## Usage Example

Under construction