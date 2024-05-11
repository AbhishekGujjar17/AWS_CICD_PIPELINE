# DevOps CI/CD Deployment Pipeline with AWS and Terraform
![img1.png](img1.png)
This project implements a full deployment pipeline on AWS using various services such as CodeCommit, CodeBuild, CodePipeline, ECS (Elastic Container Service), Target Groups, Application Load Balancer (ALB), and ECS Fargate. The pipeline automates the process of deploying code changes to an ECS Fargate cluster.

## Overview

The deployment pipeline consists of the following stages:

1. **CodeCommit**: Developers push code changes to a CodeCommit repository.
2. **CodeBuild**: CodeBuild automatically clones the repository, creates a container image, and stores it in Amazon ECR (Elastic Container Registry).
3. **CodePipeline**: CodePipeline orchestrates the workflow, triggering builds on commit and deploying the application.
4. **ECS Cluster Creation**: CodeDeploy creates an ECS Cluster to manage the deployment.
5. **Target Groups and ALB**: Target Groups and Application Load Balancer are provisioned to manage traffic to the ECS Fargate tasks.
6. **Deployment to ECS Fargate**: CodePipeline deploys the containerized application to ECS Fargate.

## Setup Instructions

### Prerequisites

1. **AWS Account**: Ensure you have an AWS account with the necessary permissions to create and manage resources.
2. **CodeCommit Repository**: Create a CodeCommit repository to store your application code.
3. **IAM Roles**: Set up IAM roles with appropriate permissions for CodeBuild, CodeDeploy, and CodePipeline.
4. **ECS Cluster**: Optionally, you can pre-create an ECS cluster, or it will be created as part of the deployment pipeline.

### Deployment Steps

1. **Clone the Repository**: Clone this repository to your local machine.

    ```bash
    git clone https://github.com/your-repo/aws-devops-cicd-pipeline.git
    ```

2. **Configure CodeBuild**: Update the `buildspec.yml` file to define the build steps required for your application.

3. **Create the Deployment Pipeline**: Create a new CodePipeline in the AWS Management Console. Configure the source as your CodeCommit repository, and set up the build and deploy stages.

4. **Configure ECS Cluster**: If not pre-created, configure the ECS cluster as per your requirements. Ensure it has necessary security groups, IAM roles, and other configurations.

5. **Set Up Target Groups and ALB**: Configure the Application Load Balancer with appropriate listeners and rules. Create Target Groups for routing traffic to ECS Fargate tasks.

6. **Run the Pipeline**: Trigger the pipeline either manually or by committing changes to your CodeCommit repository. The pipeline will automatically build and deploy your application to ECS Fargate.

## Contributors

- [Your Name](https://github.com/your-account) - Project Lead

## License

This project is licensed under the [MIT License](LICENSE).
