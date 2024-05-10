module "aws-devops-pipeline" {
  source = "../terraform/aws-devops-pipeline-module"
  vpc_id = "PUT_YOUR_VPC_ID_HERE"
}