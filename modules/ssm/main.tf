

#dev or prod or...
variable "environment" {
  type = string
}

variable "ssmparamkeys" {
  type = map(any)
}

resource "aws_ssm_parameter" "slack_secrets" {
  for_each  = var.ssmparamkeys
  type      = "SecureString"
  name      = "/pssst/${var.environment}/${each.key}"
  value     = each.value
  # overwrite = true
  # lifecycle {
  #   ignore_changes = [value, version]
  # }
}

