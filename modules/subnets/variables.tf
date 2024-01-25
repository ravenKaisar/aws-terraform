variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
  default     = null
}

variable "subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
    allow_public_ip   = bool # Only applicable for public subnets
  }))
  description = "List of subnets with their configurations"
  default     = []
}
