
variable "bucket_name" {
  type    = string
  default = "pssst"
}

variable "environment" {
  type = string
}

variable "tags" {
  type        = map(any)
  description = "tags to apply to resource"
  default     = {}
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_website_configuration" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.bucket
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_acl" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.bucket
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

#TODO: CORS configuration

output "data" {
  value = {
    bucket_arn      = aws_s3_bucket.web_bucket.arn
    bucket_endpoint = aws_s3_bucket_website_configuration.web_bucket.website_endpoint
  }
}