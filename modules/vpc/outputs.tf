output "vpc_id" {
  value = resource.aws_vpc.poridhi.id
}
output "public_route_table_info" {
  value = element([
    for route_table in resource.aws_route_table.poridhi_route_table : route_table
    if route_table.tags.Name == "PoridhiPublicRouteTable"
  ], 0)
}

output "private_route_table_info" {
  value = element([
    for route_table in resource.aws_route_table.poridhi_route_table : route_table
    if route_table.tags.Name == "PoridhiPrivateRouteTable"
  ], 0)
}
