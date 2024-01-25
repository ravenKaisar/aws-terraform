locals {
  vpc_name                 = var.vpc_name
  ipv4_primary_cidr_block  = var.ipv4_primary_cidr_block
  instance_tenancy         = var.instance_tenancy
  dns_hostnames_enabled    = var.dns_hostnames_enabled
  dns_support_enabled      = var.dns_support_enabled
  internet_gateway_enabled = var.internet_gateway_enabled
  internet_gateway_name    = var.internet_gateway_name
  elastic_ip_enabled       = var.elastic_ip_enabled
  elastic_ip_name          = var.elastic_ip_name
  elastic_ip_domain        = var.elastic_ip_domain
  nat_gateway_enabled      = var.nat_gateway_enabled
  nat_gateway_name         = var.nat_gateway_name
  nat_gateway_subnet_id    = var.nat_gateway_subnet_id
  route_tables             = [for route_table in var.route_tables : route_table]
  public_subnets           = var.public_route_table_association.subnets
  public_route_table_id    = var.public_route_table_association.route_table_id
  private_subnets          = var.private_route_table_association.subnets
  private_route_table_id   = var.private_route_table_association.route_table_id
}

resource "aws_vpc" "poridhi" {
  cidr_block           = local.ipv4_primary_cidr_block
  enable_dns_hostnames = local.dns_hostnames_enabled
  enable_dns_support   = local.dns_support_enabled
  instance_tenancy     = local.instance_tenancy
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_internet_gateway" "poridhi_internet_gateway" {
  count  = local.internet_gateway_enabled ? 1 : 0
  vpc_id = resource.aws_vpc.poridhi.id
  tags = {
    Name = local.internet_gateway_name
  }
}

resource "aws_eip" "poridhi_elastic_ip" {
  count  = local.elastic_ip_enabled ? 1 : 0
  domain = local.elastic_ip_domain
  tags = {
    Name = local.elastic_ip_name
  }
}

resource "aws_nat_gateway" "poridhi_nat_gateway" {
  # depends_on    = [module.subnets.public_subnet_info]
  count         = local.internet_gateway_enabled && local.nat_gateway_enabled ? 1 : 0
  allocation_id = resource.aws_eip.poridhi_elastic_ip[0].id
  subnet_id     = local.nat_gateway_subnet_id
  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_route_table" "poridhi_route_table" {
  count  = length(local.route_tables)
  vpc_id = resource.aws_vpc.poridhi.id
  route {
    cidr_block     = local.route_tables[count.index].destination_cidr
    gateway_id     = local.route_tables[count.index].use_internet_gateway ? resource.aws_internet_gateway.poridhi_internet_gateway[0].id : null
    nat_gateway_id = local.route_tables[count.index].use_nat_gateway ? resource.aws_nat_gateway.poridhi_nat_gateway[0].id : null
  }
  tags = {
    Name = local.route_tables[count.index].name
  }
}

resource "aws_route_table_association" "poridhi_public_route_table_association" {
  for_each       = local.public_subnets
  subnet_id      = each.value
  route_table_id = local.public_route_table_id
}

resource "aws_route_table_association" "poridhi_private_route_table_association" {
  for_each       = local.private_subnets
  subnet_id      = each.value
  route_table_id = local.private_route_table_id
}
