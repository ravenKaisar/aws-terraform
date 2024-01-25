locals {
  inline                   = var.inline_rules_enabled
  security_groups          = var.security_groups
  sg_create_before_destroy = var.create_before_destroy
}

resource "aws_security_group" "poridhi_security_group" {
  count = length(local.security_groups)

  name = local.security_groups[count.index].name
  # lifecycle {
  #   create_before_destroy = false
  # }

  description = local.security_groups[count.index].description
  vpc_id      = var.vpc_id

  # revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = local.security_groups[count.index].ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = local.security_groups[count.index].egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  timeouts {
    create = var.security_group_create_timeout
    delete = var.security_group_delete_timeout
  }
}

