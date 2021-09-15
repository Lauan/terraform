# terraform-aws-eksworkers

## Requirements / Providers

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.47 |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name for tagging purposes (e.g. development, stage or production) | string | N/A | Yes |
| application | Main identifier of the application | string | N/A | Yes |
| region | Region where the resources will be deployed | string | N/A | Yes |
| enable_instance_detailed_monitoring | If TRUE, metrics are available in 1-minute periods (instead of 5-minute period if FALSE | bool | false | No |
| workers_instance_type | Instance type for instances running in the launch template (i.e. t3.small, etc) | string | N/A | Yes |
| enable_spot_instances | If TRUE, the node group will be created with spot instances. | bool | false | No |
| desired_instances | Desired number of worker nodes | number | N/A | Yes |
| max_instances | Maximum number of worker nodes | number | N/A | Yes |
| min_instances | Minimum number of worker nodes | number | N/A | Yes |

## Deployed Resources (# of instances)

- aws_eks_node_group (1)
- aws_launch_template (1)

## Output Variables

| Name | Description |
|------|-------------|
nodegroup_name | Name of the NodeGroup |
capacity_type | NodeGroup's capacity type (OnDemand or Spot) |
instance_type | NodeGroup's instance type |

## Usage Example

This live configuration is designed to create several resources by looping through the same module multiple times.
This special configuration is made at main.tf (using the for_each feature) and variable.tf (by creating a new kind of variable to accept maps of objects)

```js
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.47.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "eks_workers" {
  source = {REGISTRY_PATH_OR_URL}
  for_each = var.node_groups_specs

  environment = var.environment
  application = var.application
  region = var.region
  enable_instance_detailed_monitoring = each.value["enable_instance_detailed_monitoring"]
  workers_instance_type = each.value["workers_instance_type"]
  enable_spot_instances = each.value["enable_spot_instances"]
  desired_instances = each.value["desired_instances"]
  max_instances = each.value["max_instances"]
  min_instances = each.value["min_instances"]
}
```

### variable.tf

```js
variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "application" {
  description = "Main identifier of the application"
}

variable "region" {
  description = "Region where the resources will be deployed"
  type        = string
}

variable "node_groups_specs" {
  type = map(object({
    enable_instance_detailed_monitoring = bool,
    workers_instance_type = string,
    enable_spot_instances = bool,
    desired_instances = number,
    max_instances = number,
    min_instances = number,
  }))
  description = "Map of values to be used as parameters for Node Groups. Check the documentation to see how to pass this argument"
}
```

### terraform.auto.tfvars

```js
environment = "value"
application = "value"
region = "value"
node_groups_specs = {
  "group1" = {
    enable_instance_detailed_monitoring = false,
    workers_instance_type = "value",
    enable_spot_instances = false,
    desired_instances = 1,
    max_instances = 2,
    min_instances = 1,
  },
  "group2" = {
    enable_instance_detailed_monitoring = false,
    workers_instance_type = "value",
    enable_spot_instances = false,
    desired_instances = 1,
    max_instances = 4,
    min_instances = 1,
  }
}
```