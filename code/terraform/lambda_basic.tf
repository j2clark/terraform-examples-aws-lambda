data "archive_file" "lambda_basic_package" {
  type = "zip"
  source_file = "../lambda_basic/index.js"
  output_path = "index.zip"
}

resource "aws_lambda_function" "basic" {
  function_name = "${var.project_name}-${var.branch}-basic"
  filename = "index.zip"
  role = data.aws_iam_role.execution_role.arn
  handler = "index.handler"
  runtime = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_basic_package.output_base64sha256

  tags = local.common_tags
}

output "lambda_function" {
  value = aws_lambda_function.basic.function_name
}