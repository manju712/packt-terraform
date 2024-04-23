This is a sample code used to show how the we provision the VPC, Subnets, IGW, Route Tables using the root module.  
In this setup, we use main.tf to launch the resources. 
The variables and outputs are also defined accordingly. 

This folder contains example code to show how the root module works(without any child modules).
It provisions the VPC, Subnets, IGW and Route Table.

The focus here is to show the working of the root module and the steps followed to create 
the resources may not be production grade. 

This folder contains following files and folders:
main.tf          - This is the main file where the Terraform resource blocks are used to create the resources. 
variables.tf     - This has the variables for which the user will have to pass the value either through the      ".tfvars" file or during the CLI execution or Environment variable. Here we use ".tfvars" to pass the value. 
terraform.tfvars - This has the values for the variables defined in the variables.tf file. 
outputs.tf       - This has the code to get the output details of the resources that gets created. 

Usage:
Make sure you have cloned the repository. If not, run the following command:
git clone https://github.com/manju712/packt-terraform.git

Navigate to the folder which has code related to local module:
cd packt-terraform/chapter_5/root-module-example/

Initialize Terraform:
terraform init

Run the Terraform plan:
terraform plan

Run Terraform apply with no prompt:
terraform apply -auto-approve

Once you are done with the exercise, make sure to delete the resources. 
Make sure you are in the right folder before running the below command as it will delete all the resources without asking for any confirmation. 
terraform destroy -auto-approve 

In this example, you will create below resources:
A VPC with the CIDR block 10.50.0.0/16 and three subnets of CIDR block 10.50.1.0/24, 10.50.2.0/24, 10.50.3.0/24 are created.
Internet Gateway is created. 
A route table is created with a single route 1.2.3.4/32 to show how the route can be added to route table. 

Input:
vpc_cidr_block     - This is the CIDR block of VPC
subnet_cidr_block  - With this variable you supply the cidr block for the subnets

Output:
vpc_id      - This gives the VPC ID that got created. 
subnets_id  - ID of all provisioned subnets.
igw         - This gives the Internet Gateway's ID. 