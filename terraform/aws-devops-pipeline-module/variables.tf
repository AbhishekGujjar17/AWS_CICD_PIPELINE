variable "vpc_id" {
  type        = string
  description = "Id of the vpc where this project will be deployed."
}

variable "branch_name" {
  type        = string
  description = "Branch name of the code commit repository"
  default     = "master"
}

variable "project_name" {
  type        = string
  description = "Name for this project"
  default     = "devops-cicd-aws"
}

variable "environment" {
  type        = string
  description = "Environment name where you want to deploy this project"
  default     = "dev"
}
