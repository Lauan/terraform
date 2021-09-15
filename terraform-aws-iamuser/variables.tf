variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "application" {
  description = "Name of the application this user is part of"
  type        = string
}

variable "component" {
  description = "Name of the component this user is part of"
  type        = string
}

variable "repository" {
  description = "Name of the repository that uses this role"
  type        = string
}

variable "username" {
  description = "Name for the User"
  type        = string
}

variable "userpath" {
  description = "Path for the user to be created at. If the user is being created for a pipeline run, this value should be pipeline"
  type        = string
}

variable "awspolicies" {
  description = "List of AWS managed policies to be attached to the user."
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

variable "extra_tags" {
  description = "Map with extra tags to add to the user"
  type        = map(string)
  default     = {}
}