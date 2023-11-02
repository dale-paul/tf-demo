

variable "role_arn" {
  type        = string
  description = "Execution role for this lambda"
}

variable "environment" {
  type        = string
  description = "environment to deploy to"
}

variable "source_path" {
  type        = string
  description = "path to source zip file"
}

variable "lambda_name" {
  type        = string
  description = "Name of lambda function"
}

variable "tags" {
  type        = map(any)
  description = "Map of enviornment varialbes to deploy to lambda"
  default     = {}
}

variable "env_variables" {
  type        = map(any)
  description = "Environment variables to set in lambda"
}

variable "enabled" {
  type        = bool
  description = "set to false to disable deploying resources in this module"
  default     = true
}

data "template_file" "swaggerdoc" {
  template = file("${path.module}/swagger.json.tpl")
  vars = {
    invoke_arn = length(aws_lambda_function.api_handler) > 0 ? aws_lambda_function.api_handler[0].invoke_arn : "noop"
  }
}

resource "aws_lambda_function" "api_handler" {
  count         = var.enabled ? 1 : 0
  filename      = var.source_path
  role          = var.role_arn
  function_name = "${var.lambda_name}-${var.environment}"
  handler       = "app.app"
  runtime       = "python3.8"
  memory_size   = 1024
  timeout       = 15
  # Wack-a-doodle hack to allow the plan/apply to succeed since the code file might not be built.
  # The code file will be build after you say "yes" to the apply
  source_code_hash = fileexists(var.source_path) ? filebase64sha256(var.source_path) : null
  environment {
    variables = var.env_variables
  }
  tags = var.tags
}

resource "aws_api_gateway_rest_api" "rest_api" {
  count              = var.enabled ? 1 : 0
  name               = "${var.lambda_name}-${var.environment}"
  binary_media_types = ["application/octet-stream"]
  body               = data.template_file.swaggerdoc.rendered
  endpoint_configuration {
    types = ["EDGE"]
  }
  tags = var.tags
}

resource "aws_api_gateway_deployment" "rest_api" {
  count             = var.enabled ? 1 : 0
  stage_name        = var.environment
  rest_api_id       = aws_api_gateway_rest_api.rest_api[0].id
  stage_description = md5(data.template_file.swaggerdoc.rendered)
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "rest_api_invoke" {
  count         = var.enabled ? 1 : 0
  function_name = aws_lambda_function.api_handler[0].arn
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api[0].execution_arn}/*"
}

output "data" {
  value = {
    swagger      = data.template_file.swaggerdoc.rendered
    endpoint_url = length(aws_api_gateway_deployment.rest_api) > 0 ? aws_api_gateway_deployment.rest_api[0].invoke_url : null
    rest_api_id  = length(aws_api_gateway_deployment.rest_api) > 0 ? aws_api_gateway_rest_api.rest_api[0].id : null
  }
}