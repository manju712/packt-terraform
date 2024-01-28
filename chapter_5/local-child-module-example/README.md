This is a sample code used to show how the vpc, security group, keypair and ec2 gets provisioned in the root module. 
Here we have moved the resource block of main.tf into their own configuration file. This makes no difference to Terraform but is easy for the user to understand. 
The variables and outputs are also defined accordingly. 