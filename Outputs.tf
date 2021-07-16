output "vpcid" {
    description = "vpc id"
    value = aws_vpc.main.id  
}

output "subnetidpublic" {
  description = "public subnet id"
  value       = aws_subnet.public.id
}

output "subnetidprivate" {
  description = "private subnet id"
  value       = aws_subnet.private.id
}


output "igwid" {
  description = "internet gateway id"
  value       = aws_internet_gateway.gw.id
}

/*
output "ngwid" {
  description = "nat gateway id"
  value       = aws_nat_gateway.ng.id
}

output "rtid" {
  description = "route table id"
  value       = aws_route_table.rt.id
}
*/