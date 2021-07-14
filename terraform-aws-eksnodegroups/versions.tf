terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws        = ">= 3.47.0"
    local      = ">= 1.4"
    // kubernetes = ">= 1.11.1"
    // http = {
    //   source  = "terraform-aws-modules/http"
    //   version = ">= 2.4.1"
    // }
  }
}