variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "application" {
  description = "Name of the application this role is part of"
  type        = string
}

variable "repository" {
  description = "Name of the repository that uses this role"
  type        = string
}

variable "component" {
  description = "Name of the component this role is part of"
  type        = string
}

variable "rolename" {
  description = "Name for the Role"
  type        = string
}

variable "roledescription" {
  description = "A brief description about the role to be created"
  type        = string
}

variable "rolepath" {
  description = "Path for the role to be created at. If the user is being created for a pipeline run, this value should be pipeline"
  type        = string
}

variable "service_principal" {
  description = "Service principal that will assume this role (ex: lambda.amazonaws.com)"
  type        = list(string)
}

variable "managed_policy_arns" {
  description = "List of AWS Managed Policies to attach to this role."
  type        = list(string)
  default     = []
}


variable "policystatements" {
  description = "List of maps containing the name (string), policyactions (list) and policyresources (list) for each statement on the policy to be created"
  type        = map(object({
    policyactions = list(string)
    policyresources = list(string)
  }))
}

variable "policyname" {
  description = "Name for the Policy"
  type        = string
}