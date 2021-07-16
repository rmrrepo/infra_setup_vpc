variable "vpc_cidr" {
    description = "vpc cidr"
    type = string
    default = "10.10.0.0/16"  
}

variable "subnet_public_cidr" {
    description = "subnet cidr"
    type = string
    default = "10.10.1.0/24"  
}
variable "subnet_private_cidr" {
    description = "subnet cidr"
    type = string
    default = "10.10.2.0/24"  
}


variable "region" {
    description = "region"
    type = string
    default = "us-west-2"  
}

variable "vpcname" {
    description = "vpc tag name"
    type = string
    default = "Demo_VPC"  
}

variable "subnetname_public" {
    description = "subnet tag name"
    type = string
    default = "subnet_public"  
}
variable "subnetname_private" {
    description = "subnet tag name"
    type = string
    default = "subnet_private"  
}