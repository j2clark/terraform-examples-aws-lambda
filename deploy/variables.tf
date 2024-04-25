variable "branch" {
  type = string
  default = "main"
}

locals {
  region       = data.aws_region.current.id
  account_id   = data.aws_caller_identity.current.id
  project_name = "terraform-examples-aws-lambda"
  github_repo  = "j2clark/terraform-examples-aws-lambda"
  buildspec    = "code/buildspec.yml"

  common_tags = {
    ProjectName = "terraform-examples-aws-lambda"
    Github = "j2clark/terraform-examples-aws-lambda"
    Branch = var.branch
  }
}
