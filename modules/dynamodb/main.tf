
#dev or prod or...
variable "environment" {
  type = string
}

variable "table_name" {
  type = string
}

variable "read_capacity" {
  type    = number
  default = 5
}

variable "write_capacity" {
  type    = number
  default = 5
}

variable "tags" {
  type        = map(any)
  description = "tags to apply to resource"
  default     = {}
}

resource "aws_dynamodb_table" "secrets_db" {
  name           = var.table_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  tags           = var.tags

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}

output "data" {
  value = {
    table_arn  = aws_dynamodb_table.secrets_db.arn
    table_name = aws_dynamodb_table.secrets_db.name
  }
}