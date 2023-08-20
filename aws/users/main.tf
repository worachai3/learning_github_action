terraform {
  backend "s3" {
    bucket         = "dev-applications-backend-state-worachai"
    key            = "dev/07-backend-state/users/backend-state"
    region         = "us-east-1"
    dynamodb_table = "dev-applications-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user" {
  for_each = toset(var.users.*.name)
  name = "${each.value}_${var.project_name}_${var.application_name}_${var.environment}"
  # name = "${var.project_name}_${var.application_name}_${var.environment}"
}