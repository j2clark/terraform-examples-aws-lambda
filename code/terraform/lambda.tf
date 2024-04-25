data "archive_file" "lambda_package" {
  type = "zip"
  source_file = "../src/index.js"
  output_path = "index.zip"
}

resource "aws_lambda_function" "html_lambda" {
  filename = "index.zip"
  function_name = "myLambdaFunction"
  role = data.aws_iam_role.execution_role.arn
  handler = "index.handler"
  runtime = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
}