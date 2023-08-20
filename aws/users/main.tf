variable application_name {
  default = "07-backend-state"
}

variable project_name {
  default = "users"
}

variable environment {
  default = "dev"
}

terraform {
  backend "s3" {
    bucket         = "dev-applications-backend-state-worachai"
    # key            = "07-backend-state-users-dev"
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
  name = "${terraform.workspace}_my_iam_user"
}