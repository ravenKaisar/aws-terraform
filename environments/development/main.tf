terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source                   = "../../modules/vpc"
  ipv4_primary_cidr_block  = "10.10.0.0/16"
  instance_tenancy         = "default"
  dns_hostnames_enabled    = true
  dns_support_enabled      = true
  internet_gateway_enabled = true
  elastic_ip_enabled       = true
  elastic_ip_domain        = "vpc"
  nat_gateway_enabled      = true
  nat_gateway_subnet_id    = module.subnets.public_subnet_info.id
  vpc_name                 = "PoridhiVPC"
  internet_gateway_name    = "PoridhiInternetGateway"
  elastic_ip_name          = "PoridhiElasticIPForPrivateSubnet"
  nat_gateway_name         = "PoridhiNatGatewayForPrivateSubnet"
  route_tables = [
    {
      name                 = "PoridhiPublicRouteTable"
      use_internet_gateway = true
      use_nat_gateway      = false
      destination_cidr     = "0.0.0.0/0"
    },
    {
      name                 = "PoridhiPrivateRouteTable"
      use_internet_gateway = false
      use_nat_gateway      = true
      destination_cidr     = "0.0.0.0/0"
    }
  ]
  # public_route_table_association = {
  #   subnets        = keys(module.subnets.public_subnets_list)
  #   route_table_id = module.vpc.public_route_table_info.id
  # }
  # private_route_table_association = {
  #   subnets        = keys(module.subnets.private_subnets_list)
  #   route_table_id = module.vpc.private_route_table_info.id
  # }
}

module "subnets" {
  source = "../../modules/subnets"
  vpc_id = module.vpc.vpc_id
  subnets = [
    {
      name              = "PoridhiPrivateSubnetZoneA"
      allow_public_ip   = false
      cidr_block        = "10.10.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "PoridhiPrivateSubnetZoneB"
      allow_public_ip   = false
      cidr_block        = "10.10.2.0/24"
      availability_zone = "us-east-1b"
    },
    {
      name              = "PoridhiPublicSubnetZoneA"
      allow_public_ip   = true
      cidr_block        = "10.10.3.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "PoridhiPublicSubnetZoneB"
      allow_public_ip   = true
      cidr_block        = "10.10.4.0/24"
      availability_zone = "us-east-1b"
    }
  ]
}

# module "security_groups" {
#   source = "../../modules/security-group"
#   vpc_id = module.vpc.vpc_id
#   security_groups = [
#     {
#       name        = "For HTTP"
#       description = "Alloy All HTTP Request"
#       ingress_rules = [
#         {
#           description = "Alloy All HTTP Request"
#           cidr_blocks = "0.0.0.0/0"
#           from_port   = "80"
#           to_port     = "80"
#           protocol    = "tcp"
#         }
#       ]
#       egress_rules = [
#         {
#           description = "Alloy All HTTP Request"
#           cidr_blocks = "0.0.0.0/0"
#           from_port   = "80"
#           to_port     = "80"
#           protocol    = "tcp"
#         }
#       ]
#     }
#   ]
# }
