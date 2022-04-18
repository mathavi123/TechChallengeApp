# Servian Tech Challenge

**TABLE OF CONTENTS:**

[Tech Challenge Overview](#tech-challenge-overview)

[Architecture](#architecture)

[Prerequisites](#prerequisites)

[Create IAM Role for EC2 and CodeDeploy](#create-iam-role-for-ec2-and-codedeploy)

[Create SecurityGroup](#create-securitygroup)

[Create EC2 Instance](#create-ec2-instance)

[Connect EC2 Instance](#connect-ec2-instance)

[Install CodeDeploy Agent on EC2 Instance](#install-codedeploy-agent-on-ec2-instance)

[GitHub Project](#github-project)

[CodeDeploy Service Configuration (appspec.yml,setup.sh and startapp.sh)](#codedeploy-service-configuration)

[GitHub Action](#github-action)






## Tech Challenge Overview:
This project was made as a requirement during the Servian's interview process. As part of my current work, I had only chance to work in provisioning the resources to application team and troubleshoot if any other issues. The project is fully based on DevOps Engineer role and I had idea about the CI/CD, but not implemented in production environment. However, I managed to deploy the application manually EC2 instance with AWS CodeDeploy, still am working in the code to add the actions in GitHub Actions to do CI/CD part.

## Architecture:

![image](https://user-images.githubusercontent.com/39115469/163870082-1ae4958f-854e-4f2c-9c9a-29bfdc06a751.png)

## Prerequisites:
1.	Create a [GitHub](https://github.com/) account.
2.	Create [AWS](https://aws.amazon.com/console/) Account.

We need to select a particular region of AWS Services which CodeDeploy Agent and GitHub will use.
**How to Deploy:**
## Create IAM Role for EC2 and CodeDeploy:
### 1. Create a role for EC2 Instance:
1.	Select **AWS Service** as trusted entity and **EC2** as usecase, click on Next:Permissions.
2.	On the Permissions page, select **AmazonEC2RoleforAWSCodeDeploy** Policy and Click on Next:Tags

![image](https://user-images.githubusercontent.com/39115469/163871062-e4e1339e-df76-4e71-b31a-1a44299edf40.png)![image](https://user-images.githubusercontent.com/39115469/163871082-30af0aa0-f529-4a78-8a22-b197d0c6f30b.png)

3.	Ignore the tags and click Next:Review.
4.	Provide the role name as **ec2_role2** on the review page.
5.	Open the **ec2_role2** and go to Trust Relationships, then Edit Trust Relationship and paste below policy –

![image](https://user-images.githubusercontent.com/39115469/163871167-86d4f11d-3613-41c3-9dac-881262cf907a.png)
![image](https://user-images.githubusercontent.com/39115469/163871183-c4b40053-6d0d-49dd-97f0-7b3afa50fcd4.png)

### 2. Create a role for CodeDeploy:
1.	Select AWS Service as trusted entity and EC2 as usecase, click on Next:Permissions.
2.	On the Permissions page, select the below policy and Click on Next:Tags.** AmazonEC2FullAccess, AWSCodeDeployFullAccess, AdministratorAccess, AWSCodeDeployRole**
3.	Tags can be ignored, click on Next:Review.
4.	Provide the role name as **code_deployer_role** on the review page.

![image](https://user-images.githubusercontent.com/39115469/163871509-3fbebc32-40d1-483a-b967-547dff911990.png)

Once CodeDeploy Role created, Open the **code_deployer_role** and go to Trust Relationships then Edit Trust Relationship and use below policy -

![image](https://user-images.githubusercontent.com/39115469/163873297-907bebd3-fca0-4eeb-966f-b02756a262ec.png)


## Create SecurityGroup:
We need create a security group with inbound rule which should allow port 3000 to access the Servian TechChallenge App URL from anywhere and SSH to install the CodeDeploy Agent on it. 
![image](https://user-images.githubusercontent.com/39115469/163871726-e42de262-89a4-45f7-9852-a0ceefb144e0.png)

## Create EC2 Instance:
To create an EC2 instance, Go to EC2 Dashboard on AWS Management Console and click on **Launch Instance**.

On the AIM page, you can select any Volume Type based on your requirement. This article will choose Free Tier **Ubuntu Server 20.04 LTS, SSD Volume Type and 64-bit (x86) Volume** and click on select.
Select t2.micro in Choose Instance Typ page and proceed to Configure Instance page. Provide name as **ServianApp_Server**.

![image](https://user-images.githubusercontent.com/39115469/163871763-57c0c4fe-5bdc-4b09-ac52-1cce2b248340.png) ![image](https://user-images.githubusercontent.com/39115469/163871776-fca1bb53-2628-46a3-84a4-123606d76459.png)

To establish the connection between EC2 instance and codeDeploy, Select **ec2_role2**, which we created before.
![image](https://user-images.githubusercontent.com/39115469/163871814-80d5d632-0f06-4d0e-95fe-23d56fb45c60.png)

In Configure Security Group, add the SecurityGroup which we created above **ServianApp-SG**.

## Connect EC2 Instance:
Once Instance is up and running, Right-click on instance id and click on connect. On the next page, Take a note of the **Public IP Address** and connect using the default **User name**.
![image](https://user-images.githubusercontent.com/39115469/163871885-d1683406-e373-4840-b68a-fe874fc2bd71.png)

## Install CodeDeploy Agent on EC2 Instance:
To deploy the git repo by using CodeDeploy Service, **CodeDeploy-agent** must install in the EC2 instance.

Use the below commands to install codedeploy-agent.

**To install the CodeDeploy agent on Ubuntu Server,**

1.	Sign in to the instance. 

2.	On Ubuntu Server 16.04 and later, enter the following commands, one after the other:

    sudo apt update

    sudo apt install ruby-full

  sudo apt install wget

3.	Enter the following command:
	
    cd /home/ubuntu
  
    /home/ubuntu represents the default user name for an Ubuntu Server instance. If your instance was created using a custom AMI, the AMI owner might have specified a  different default user name.

4.	Enter the following command:
	
    wget https://bucket-name.s3.region-identifier.amazonaws.com/latest/install
  
    bucket-name is the name of the Amazon S3 bucket that contains the CodeDeploy Resource Kit files for your region.
  
    region-identifier is the identifier for your region.   
  
    For example, for the US East (Ohio) Region, replace bucket-name with aws-codedeploy-us-east-2 and replace region-identifier with us-east-2. For a list of bucket  names and region identifiers, see [Resource kit bucket names by Region](https://docs.aws.amazon.com/codedeploy/latest/userguide/resource-kit.html#resource-kit-bucket-names).
  
    wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
  
5.	Enter the following command:

    chmod +x ./install
  
6.	To install the latest version of the CodeDeploy agent on Ubuntu 14.04, 16.04, and 18.04:

    sudo ./install auto
  
**To check that the service is running**

    1. Enter the following command:

      sudo service codedeploy-agent status

      If the CodeDeploy agent is installed and running, you should see a message like The AWS CodeDeploy agent is running.

    2.	If you see a message like error: No AWS CodeDeploy agent running, start the service and run the following two commands, one at a time:

      sudo service codedeploy-agent start

      sudo service codedeploy-agent status

## GitHub Project:

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) the [servian/TechChallengeApp](https://github.com/servian/TechChallengeApp) repository.

Clone the forked repository to local desktop.

This project is a GoLang which uses Postgres DB.

For project deployment, we will use shell script, which includes installation of Postgres DB.

We need to create [appspec.yml](https://github.com/mathavi123/TechChallengeApp/blob/master/appspec.yml), [setup.sh](https://github.com/mathavi123/TechChallengeApp/blob/master/setup.sh) and [startapp.sh](https://github.com/mathavi123/TechChallengeApp/blob/master/startapp.sh) files on local desktop, then commit it to forked repository in GitHub.

The appspec.yml file used by codeDeploy to manage the deployment. 

The setup.sh will install all required software packages, updates and TechChallenge App. The startapp.sh is used for starting the TechChallengeApp after installing it.

Once created, we need to push these files to GitHub repository.

On Local deskop, we need to have git client.

After run the command, git init 

Then creating files appspec.yml, setup.sh, appstart.sh
Then, git add appspec.yml

git add setup.sh

git add appspec.yml

git add startapp.sh

git commit -m "corrected startapp.sh"

git push https://github.com/mathavi123/TechChallengeApp.git

![image](https://user-images.githubusercontent.com/39115469/163871990-8da6b472-f550-4313-ac04-36614ea7cc65.png) ![image](https://user-images.githubusercontent.com/39115469/163872006-48b01765-49ec-4e5a-83a4-c79eea36981a.png)

## CodeDeploy Service Configuration:
AWS [CodeDeploy Service](https://docs.amazonaws.cn/en_us/codedeploy/latest/userguide/welcome.html) will automate the GitHub application deployment to EC2.

Create an Application name called **Servain_App** with compute platform **EC2/On-premises**.

GitHub Action will use the application name.

Choose **In-place** Deployment type. Select Amazon Ec2 Instances environment configuration and Tag key **ServianApp_Server** to create AWS EC2 instance.

Select a schedule manager to install the CodeDeploy agent. Set OneAtATime deployment setting and Create Deployment Group without a load balancer. After testing it on one instance, we can create load balancer and auto scaling group when integrating with CodePipeline.
 
![image](https://user-images.githubusercontent.com/39115469/163872060-c7c78972-01f6-4c88-a6f1-7329ee5f07b6.png)
![image](https://user-images.githubusercontent.com/39115469/163872071-1ee0dd41-7fbe-4be8-b35d-504844c63781.png)
![image](https://user-images.githubusercontent.com/39115469/163872081-6eeafc71-ffae-48e6-bb17-6132bf02080e.png)

Once Deployment Group created, test the deployment by creating a Deployment with any name.

Select Revision Type **My application is stored in GitHub**, and select **Connect to GitHub **by providing the GitHub token.

Once connected to GitHub, Provide the [mathavi123/TechChallengeApp](https://github.com/mathavi123/TechChallengeApp) and last Commit ID. Select Overwrite the content and Create Deployment.

![image](https://user-images.githubusercontent.com/39115469/163872114-af21035a-a00d-45f6-b622-5a6093d58255.png) ![image](https://user-images.githubusercontent.com/39115469/163872127-dc1a8e7a-a025-447c-b2f8-35794c66e795.png)

![image](https://user-images.githubusercontent.com/39115469/163872143-c17340c5-a225-488c-ac82-2a7b4d5f036c.png) ![image](https://user-images.githubusercontent.com/39115469/163872156-4bdb9b82-0c13-49f0-8138-80e46ef0c411.png)
![image](https://user-images.githubusercontent.com/39115469/163872163-333afd85-631f-4261-a52c-80f277bab699.png)

Wait for a few minutes ⏳ .
If Deployment status is unsuccessful, verify the deployment logs from ec2 instance /var/log/aws/codedeploy-agent/codedeploy-agent.log.
Recreate the deployment and fix this first. Once it's successful, you can access the application from a web browser or postman.

## Challenges:
•	It is quite challenging to deploy the entire stack on AWS. It was the first time I did this from scratch. Currently, I mostly support infrastructure as service  like provisioning, configuring AWS services  and will do troubleshooting if any issues on those services. I have some basic knowledge about CI/CD and have done a small project in CI/CD pipeline a long back for project purpose while doing PGP in Cloud Computing course.
•	Still I need some more time to implement CI/CD pipeline through GitHub actions and to write yml code to auto provision the AWS services when there is a commit in repository. 
•	I learned a lot of concepts from this project and am confident that I will implement it fully in few days with this CI/CD implementation.
 ## Future Recommendations:
•	Once I complete full implemented, I can give some recommendations.










