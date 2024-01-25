locals {
  vpc_id  = var.vpc_id
  subnets = [for subnet in var.subnets : subnet]
}

resource "aws_subnet" "poridhi_subnets" {
  count                   = length(local.subnets)
  vpc_id                  = local.vpc_id
  cidr_block              = local.subnets[count.index].cidr_block
  availability_zone       = local.subnets[count.index].availability_zone
  map_public_ip_on_launch = local.subnets[count.index].allow_public_ip

  tags = {
    Name = local.subnets[count.index].name
  }
}
