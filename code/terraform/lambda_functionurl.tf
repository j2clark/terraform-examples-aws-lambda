data "archive_file" "lambda_functionurl_package" {
  type = "zip"
  source_file = "../lambda_functionurl/index.js"
  output_path = "index.zip"
}

resource "aws_lambda_function" "lambda_functionurl" {
  function_name = "${var.project_name}-${var.branch}-functionurl"
  filename = "index.zip"
  role = data.aws_iam_role.execution_role.arn
  handler = "index.handler"
  runtime = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_functionurl_package.output_base64sha256
  publish = true

  tags = local.common_tags
}

resource "aws_lambda_function_url" "functionurl" {
  function_name      = aws_lambda_function.lambda_functionurl.function_name
  authorization_type = "NONE"
  /*cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["GET,POST"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }*/
}

output "lambda_functionurl" {
  value = aws_lambda_function.lambda_functionurl.function_name
}

output "lambda_functionurl_endpoint" {
  value = aws_lambda_function_url.functionurl.function_url
}