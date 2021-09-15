variable "ecr_repositories" {
  type = map(object({
    component = string,
    repository = string,
    tag_overriding = bool,
    enable_scan = bool
  }))
  description = "Map of values to be used as parameters for ECR repositories. Required values are: name, tag_overriding and enable_scan"
}

variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "application" {
  description = "Main identifier of the application"
}