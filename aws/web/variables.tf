variable "aws_private_key" {
  default = "./default-ec2.pem"
  description = "SSH private key"
}

variable "is_github_actions" {
  description = "Flag to indicate if running in GitHub Actions"
  type        = bool
  default = false
}