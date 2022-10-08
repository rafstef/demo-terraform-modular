locals {
    env = {
        DEV ="dev"
        BUGFIXING = "bugfixing"
        PREPROD = "preprod"
        PROD = "prod"
    }
    
    azs  = {
        DEV = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
        BUGFIXING = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
        PREPROD = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
        PROD = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    }

    cidr = {
        DEV = "10.0.0.0/16"
        BUGFIXING = "10.0.0.0/16"
        PREPROD = "10.0.0.0/16"
        PROD = "10.0.0.0/16"
    }
    private_subnets = {
        DEV = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
        BUGFIXING = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
        PREPROD = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
        PROD = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
    }

    public_subnets = {
        DEV = ["10.0.13.0/24", "10.0.14.0/24", "10.0.15.0/24"]
        BUGFIXING = ["10.0.16.0/24", "10.0.17.0/24", "10.0.18.0/24"]
        PREPROD = ["10.0.19.0/24", "10.0.20.0/24", "10.0.21.0/24"]
        PROD = ["10.0.22.0/24", "10.0.23.0/24", "10.0.34.0/24"]
    }
}