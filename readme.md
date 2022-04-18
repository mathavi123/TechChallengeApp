# Servian Tech Challenge

TABLE OF CONTENTS:

[Tech Challenge Overview](#1-tech-challenge-overview)

[Architecture](#Architecture:)
[Create IAM Role for EC2 and CodeDeploy][#Create-IAM-Role-for-EC2-and-CodeDeploy:]
[Create SecurityGroup]
[Create EC2 Instance]
[Connect EC2 Instance]
[Install CodeDeploy Agent on EC2 Instance]
[GitHub Project]
[CodeDeploy Service Configuration (appspec.yml, setup.sh and startapp.sh)]
[GitHub Action]





## Tech Challenge Overview:
This project was made as a requirement during the Servian's interview process. As part of my current work, I had only chance to work in provisioning the resources to application team and troubleshoot if any other issues. The project is fully based on DevOps Engineer role and I had idea about the CI/CD, but not implemented in production environment. However, I managed to deploy the application manually EC2 instance with AWS CodeDeploy, still am working in the code to add the actions in GitHub Actions to do CI/CD part.

## Architecture:

![image](https://user-images.githubusercontent.com/39115469/163870082-1ae4958f-854e-4f2c-9c9a-29bfdc06a751.png)

## Prerequisites:
1.	Create a GitHub account.
2.	Create AWS Account.
We need to select a particular region of AWS Services which CodeDeploy Agent and GitHub will use.
**How to Deploy:**
## Create IAM Role for EC2 and CodeDeploy:
1. Create a role for EC2 Instance:
1.	Select AWS Service as trusted entity and EC2 as usecase, click on Next:Permissions.
2.	On the Permissions page, select AmazonEC2RoleforAWSCodeDeploy Policy and Click on Next:Tags

