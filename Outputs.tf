output "vpcid" {
    description = "vpc id"
    value = aws_vpc.main.id  
}

output "subnetid" {
  description = "subnet id"
  value       = aws_subnet.main.id
}

output "igwid" {
  description = "internet gateway id"
  value       = aws_internet_gateway.gw.id
}

output "ngwid" {
  description = "nat gateway id"
  value       = aws_nat_gateway.ng.id
}

output "rtid" {
  description = "route table id"
  value       = aws_route_table.rt.id
}