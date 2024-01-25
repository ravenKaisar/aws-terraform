variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
  default     = "PoridhiVPC"
}
variable "ipv4_primary_cidr_block" {
  type        = string
  description = <<-EOT
    The primary IPv4 CIDR block for the VPC.
    Either `ipv4_primary_cidr_block` or `ipv4_primary_cidr_block_association` must be set, but not both.
    EOT
  default     = null
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated", "host"], var.instance_tenancy)
    error_message = "Instance tenancy must be one of \"default\", \"dedicated\", or \"host\"."
  }
}

variable "dns_hostnames_enabled" {
  type        = bool
  description = "Set `true` to enable [DNS hostnames](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-hostnames) in the VPC"
  default     = true
}

variable "dns_support_enabled" {
  type        = bool
  description = "Set `true` to enable DNS resolution in the VPC through the Amazon provided DNS server"
  default     = true
}

variable "internet_gateway_enabled" {
  type        = bool
  description = "Set `true` to create an Internet Gateway for the VPC"
  default     = true
}

variable "internet_gateway_name" {
  type        = string
  description = "The name of the Internet Gateway"
  default     = "PoridhiInternetGateway"
}

variable "elastic_ip_enabled" {
  type        = bool
  description = "Set to `true` to allocate an Elastic IP"
  default     = false
}

variable "elastic_ip_name" {
  type        = string
  description = "The name of the Elastic IP"
  default     = "PoridhiElasticIPForPrivateSubnet"
}

variable "elastic_ip_domain" {
  type        = string
  description = "The domain type for the Elastic IP (standard or vpc)"
  default     = "vpc"
  validation {
    condition     = contains(["standard", "vpc"], var.elastic_ip_domain)
    error_message = "Instance tenancy must be one of \"vpc\" or  \"standard\""
  }
}

variable "nat_gateway_enabled" {
  type        = bool
  description = "Set to `true` to create a NAT Gateway, or `false` to disable it"
  default     = false
}

variable "nat_gateway_name" {
  type        = string
  description = "The name of the NAT Gateway"
  default     = "PoridhiNatGatewayForPrivateSubnet"
}

variable "nat_gateway_subnet_id" {
  type        = string
  description = "The subnet ID where the NAT Gateway should be deployed"
  default     = null
}

variable "route_tables" {
  type = list(object({
    name                 = string
    destination_cidr     = string
    use_internet_gateway = bool
    use_nat_gateway      = bool
  }))
  description = "List of route tables with their configurations"
  default     = []
}

variable "public_route_table_association" {
  type = object({
    subnets        = set(string)
    route_table_id = string
  })
  description = "Map of public subnets associations with route table ID"
  default = {
    subnets        = []
    route_table_id = ""
  }
}

variable "private_route_table_association" {
  type = object({
    subnets        = set(string)
    route_table_id = string
  })
  description = "Map of private subnets associations with route table ID"
  default = {
    subnets        = []
    route_table_id = ""
  }
}
