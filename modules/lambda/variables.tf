variable "infra_bucket" {
  type = string
}
variable "package_key_location" {
  type = string
}
variable "function_name" {
  type = string
}
variable "handler" {
  type = string
  default = "lambda.handler"
}
variable "env_vars" {
  type = map(string)
  default = {
  }
}
variable "extra_policy_arns" {
  type = list(string)
  default = []
}

variable "collector_bucket" {
  type = string
}

variable "results_bucket" {
  type = string
}