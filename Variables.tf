variable "vpc_cidr" {
    description = "vpc cidr"
    type = string
    default = "10.10.0.0/16"  
}

variable "subnet_cidr" {
    description = "subnet cidr"
    type = string
    default = "10.10.10.0/27"  
}

variable "region" {
    description = "region"
    type = string
    default = "us-west-2"  
}

variable "vpcname" {
    description = "vpc tag name"
    type = string
    default = "vpc_main"  
}

variable "subnetname" {
    description = "subnet tag name"
    type = string
    default = "subnet_main"  
}