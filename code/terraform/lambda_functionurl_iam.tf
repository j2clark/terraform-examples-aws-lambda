data "archive_file" "lambda_functionurl_iam_package" {
  type = "zip"
  source_file = "../lambda_functionurl_iam/index.js"
  output_path = "functionurl_iam.zip"
}

resource "aws_lambda_function" "lambda_functionurl_iam" {
  function_name = "${var.project_name}-${var.branch}-functionurl"
  filename = "functionurl_iam.zip"
  role = data.aws_iam_role.execution_role.arn
  handler = "index.handler"
  runtime = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_functionurl_iam_package.output_base64sha256
  publish = true

  tags = local.common_tags
}

resource "aws_lambda_function_url" "functionurl_iam" {
  function_name      = aws_lambda_function.lambda_functionurl_iam.function_name
  authorization_type = "IAM"
  /*cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["GET,POST"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }*/
}

output "lambda_functionurl_iam" {
  value = aws_lambda_function.lambda_functionurl_iam.function_name
}

output "lambda_functionurl_endpoint_iam" {
  value = aws_lambda_function_url.functionurl_iam.function_url
}