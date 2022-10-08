

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.23.0"
        }  
    }
    backend "s3" {
        bucket = "202210-demo-terraform"
        key    = "demo-terraform-ec2"
        region = "eu-central-1"
    }
}

data "terraform_remote_state" "networking" {
  workspace = "${terraform.workspace}"
  backend = "s3"
  config = {
    bucket = "202210-demo-terraform"
    key    = "demo-terraform-vpc"
    region = "eu-central-1"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = "true"
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"
  name = "${lookup(local.resource_prefix, terraform.workspace)}-${lookup(local.env, terraform.workspace)}"
  cidr = "${lookup(local.cidr, terraform.workspace)}"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = "${lookup(local.private_subnets, terraform.workspace)}"
  public_subnets  = "${lookup(local.public_subnets, terraform.workspace)}"

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "${lookup(local.env, terraform.workspace)}"
  }
}

module "frontend_ec2" {
  count = "${lookup(local.backend_instance_count, terraform.workspace)}"
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.1.1"

  name = "${lookup(local.resource_prefix, terraform.workspace)}-demo-frontend-${lookup(local.env, terraform.workspace)}-${count.index}"

  ami                    =  data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "cis-italy"
  monitoring             = true
  vpc_security_group_ids = [module.default_security_group.security_group_id]
  subnet_id              = module.vpc.public_subnets[count.index]

  tags = {
    Terraform   = "true"
    Environment = "${lookup(local.env, terraform.workspace)}"
  }
}

module "backend_ec2" {
  count = "${lookup(local.backend_instance_count, terraform.workspace)}"
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.1.1"

  name = "${lookup(local.resource_prefix, terraform.workspace)}-demo-backend-${lookup(local.env, terraform.workspace)}-${count.index}"

  ami                    =  data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "cis-italy"
  monitoring             = true
  vpc_security_group_ids = [module.default_security_group.security_group_id]
  subnet_id              = module.vpc.private_subnets[count.index]

  tags = {
    Terraform   = "true"
    Environment = "${lookup(local.env, terraform.workspace)}"
  }
}

module "default_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.1"
  name = "${lookup(local.resource_prefix, terraform.workspace)}-demo-default-sg"
  vpc_id = module.vpc.default_vpc_id
  tags = {
    Terraform   = "true"
    Environment = "${lookup(local.env, terraform.workspace)}"
  }
}