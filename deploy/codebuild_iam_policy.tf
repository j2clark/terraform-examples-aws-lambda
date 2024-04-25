data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    sid = "PassExecutionRole"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = [
      data.aws_iam_role.execution_role.arn
    ]
  }

  statement {
    sid = "Logs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/*"
    ]
  }

  statement {
    sid = "CodeBuild"
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:${local.region}:${local.account_id}:report-group/${local.project_name}*"
    ]
  }

  statement {
    sid     = "ManageLambdas"
    effect  = "Allow"
    actions = [
      "lambda:GetFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:ListVersionsByFunction",
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:TagResource"
    ]
    resources = [
      "arn:aws:lambda:${local.region}:${local.account_id}:function:${local.project_name}-${var.branch}*"
    ]
  }

  statement {
    sid     = "ManageLambdaFunctionUrls"
    effect  = "Allow"
    actions = [
      "lambda:GetFunctionUrlConfig",
      "lambda:CreateFunctionUrlConfig",
      "lambda:DeleteFunctionUrlConfig",
      "lambda:UpdateFunctionCode",
      "lambda:AddPermission"
    ]
    resources = [
      "arn:aws:lambda:${local.region}:${local.account_id}:function:${local.project_name}-${var.branch}*"
    ]

  }

  statement {
    sid = "S3WriteAccessArtifacts"
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:PutObject*",
      "s3:GetObject*",
      "s3:DeleteObject*",
      "s3:GetBucket*"
    ]
    resources = [
      data.aws_s3_bucket.artifacts.arn,
      "${data.aws_s3_bucket.artifacts.arn}/${var.branch}",
      "${data.aws_s3_bucket.artifacts.arn}/${var.branch}/*"
    ]
  }
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "${local.project_name}-codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild_policy_document.json
}


resource "aws_iam_role_policy_attachment" "codebuild-role-policy-attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}