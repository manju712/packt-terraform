### IMPORTING THE KEYPAIR GENERATED OUTSIDE OF TF USING THE SSH-KEYGEN ###
# PLEASE REPLACE THE PUBLIC_KEY WITH YOUR OWN KEY
/* In Linux, you can use the command “ssh-keygen -t rsa -b 4096” which will create a private key and public key under ~/.ssh. You can copy the contents of the public key file id_rsa.pub and paste it under the “public_key” argument of aws_key_pair resource block */

resource "aws_key_pair" "root_module_kp" {
  key_name   = "root-module-kp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCh4kZjHIeWZ13Hh4POkdt2tp8IV04A2q4ncayce0BN4wPPkxLNY8PX/ZLQU6ykl4geycahZoK0kFiLKMArEp/DDWdwjsWiz9Gx+h3Pils/3z8T3kOa7IvJPGtRZVAO0Y3u2YKNbxsYCxB5N6Ipvm94j9muNm0wZBY9xsGXszosjUcuKzxcUkgR47SNLHs8+JkjnQqa2u3j4YbbxJLb44tx/Swrqhs2DKAd54zN3nPEaaofxBrG5fzezpkRw7pgnZxaqwhsFgvnQW7rs2FIMRTPbZdddtpQin93txvdMEFkyMimf0wHtCkSFCL6cLa4BUViuGioM0Tu4X2eQrTsTfu4eakPpuekuaU+Dse71VSYIxw9c/KZH2KVyyFstrd0OcIIGc8OJCYTY8igOq4iNmY9zphfmgS2mKCGjJ6hhgVMMdaO8o5MR4RnAW9Z5xEWauipruE1t9TPFPGbdz/y/zWm2wr5mx3RrGQahBveKZlpFqxmWwHuUYaWt6spOf7BEhF6H76/QlZWo/QGpNLAQtIkjqcAoURdinT2M7NsRK3fevbjuhvASbb006DrQ8mQERS6A9wICESq6Cp1H6Ns4pJ4n1+8kKHGPleEyxYtiqJ57W5x6Zz+sHrTWGDR/2zGNqHK/I+8A/KPIIC49tSRW/6c+V0hRq0Aop4Y8x7uPWZSBQ=="
}

###  CREATING VPC, SUBNET, ROUTE TABLE, IGW ###
module "vpc" {
  source            = "./modules/networking"
  vpc_cidr_block    = "10.51.0.0/16"
  vpc_name          = "child-module-vpc"
  subnet_cidr_block = "10.51.1.0/24"
  az                = "ap-south-1a"
  igw_name          = "child-module-igw"
}

###  CREATING SECURITY GROUP AND RULES ###
module "security_group" {
  source              = "./modules/security-group"
  vpc_id              = module.vpc.vpc_id
  security_group_name = "child-module-sg"
  allowed_ip          = "0.0.0.0/0"
  from_port           = "22"
  to_port             = "22"
}

### USING DATASOURCE TO GET THE LATEST AMI ###
data "aws_ami" "root_module_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

### LAUNCHING AN EC2 INSTANCE ###
module "ec2_instance" {
  source                 = "./modules/ec2"
  instance_ami           = data.aws_ami.root_module_ami.id
  instance_type          = "t3.micro"
  root_volume_size       = 11
  subnet_id              = module.vpc.subnet_id
  key_name               = aws_key_pair.root_module_kp.id
  vpc_security_group_ids = [module.security_group.sg_id]
}