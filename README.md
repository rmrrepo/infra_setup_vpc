Terraform Lab: Complete VPC setup using Terraform
Build
Setting up complete VPC. 
Create VPC, Public Subnet, Private Subnet, Create Internet Gateway and attach it to VPC, Create NAT Gateway and attach it to private subnet, Configure Route Table with Internet gateway and NAT gateway.
AWS Resources:
●	VPC
●	Subnets
●	Internet Gateway
●	Route table
●	NAT Gateway
Create a new VPC, Public subnets, Private subnets, Internet Gateway, NAT Gateway, Route tables using Terraform 
Other configuration details are listed below
●	Region: us-east-1

VPC Configuration
https://www.terraform.io/docs/providers/aws/r/vpc.html
https://www.terraform.io/docs/providers/aws/r/subnet.html
Create a VPC with the specifications listed below. Create new subnets (do not use existing subnets)
●	CIDR : 10.10.0.0/16

Resource Dependencies
	https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
https://www.terraform.io/docs/providers/aws/r/nat_gateway.html  
https://www.terraform.io/docs/providers/aws/r/route_table.html 	
1.	Create Internet Gateway and attach it to the vpc.
2.	Create NAT Gateway with Elastic IP attached to it and attach the NAT Gateway to the private subnet via Route table.
	https://www.terraform.io/docs/providers/aws/r/eip.html

Input Variables
https://www.terraform.io/intro/getting-started/variables.html
●	Create a variable.tf file within your Terraform working directory and call them within the Main Terraform file.
●	Use the following resources from variable file.
o	1.VPC CIDR
o	2.Region
o	3.Tagname for VPC and Subnets
Output Variables
https://www.terraform.io/intro/getting-started/outputs.html
▪	Display the following output variables.
1.	VPC ID
2.	Public & Private subnet IDs
3.	Internet Gateway ID
4.	NAT Gateway ID
5.	Route table ID
Sample terraform script to create VPC and Subnets given below:

#VPC

resource "aws_vpc" "test_vpc"{
  cidr_block = "${var.vpc_cidr}"
  tags {
    Name = "${var.tagname_vpc}"
  }
}


data "aws_availability_zones" "available" {}



#SUBNETS
#PublicSubnet

resource "aws_subnet" "publicsubnet"{
  count = "${var.azs_count}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.test_vpc.cidr_block, 8, count.index)}"
  tags {
    Name = "${var.public_subnet_tag}"
  }
}



Expected terraform files for this build is listed below
●	README.md 
●	Main.tf
●	Outputs.tf
●	Variables.tf


Terraform Apply
Run terraform apply to execute.
https://www.terraform.io/intro/getting-s	tarted/build.html

      [root@ip-10-0-1-19 complete-vpc-terraform]# terraform apply
data.aws_availability_zones.available: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_eip.eip_nat
      id:                                          <computed>
      allocation_id:                               <computed>
      association_id:                              <computed>
      domain:                                      <computed>
      instance:                                    <computed>
      network_interface:                           <computed>
      private_ip:                                  <computed>
      public_ip:                                   <computed>
      vpc:                                         "true"

  + aws_internet_gateway.IGW
      id:                                          <computed>
      vpc_id:                                      "${aws_vpc.test_vpc.id}"

  + aws_nat_gateway.NAT_GW
      id:                                          <computed>
      allocation_id:                               "${aws_eip.eip_nat.id}"
      network_interface_id:                        <computed>
      private_ip:                                  <computed>
      public_ip:                                   <computed>
      subnet_id:                                   "${aws_subnet.publicsubnet.0.id}"
      tags.%:                                      "1"
      tags.Name:                                   "Nat Gateway"

  + aws_route_table.Private_RT
      id:                                          <computed>
      propagating_vgws.#:                          <computed>
      route.#:                                     "1"
      route.~1416932413.cidr_block:                "0.0.0.0/0"
      route.~1416932413.egress_only_gateway_id:    ""
      route.~1416932413.gateway_id:                "${aws_nat_gateway.NAT_GW.id}"
      route.~1416932413.instance_id:               ""
      route.~1416932413.ipv6_cidr_block:           ""
      route.~1416932413.nat_gateway_id:            ""
      route.~1416932413.network_interface_id:      ""
      route.~1416932413.vpc_peering_connection_id: ""
      vpc_id:                                      "${aws_vpc.test_vpc.id}"

  + aws_route_table.Public_RT
      id:                                          <computed>
      propagating_vgws.#:                          <computed>
      route.#:                                     "1"
      route.~742396025.cidr_block:                 "0.0.0.0/0"
      route.~742396025.egress_only_gateway_id:     ""
      route.~742396025.gateway_id:                 "${aws_internet_gateway.IGW.id}"
      route.~742396025.instance_id:                ""
      route.~742396025.ipv6_cidr_block:            ""
      route.~742396025.nat_gateway_id:             ""
      route.~742396025.network_interface_id:       ""
      route.~742396025.vpc_peering_connection_id:  ""
      vpc_id:                                      "${aws_vpc.test_vpc.id}"

  + aws_route_table_association.Private_RT_IG[0]
      id:                                          <computed>
      route_table_id:                              "${aws_route_table.Private_RT.id}"
      subnet_id:                                   "${element(aws_subnet.privatesubnet.*.id, count.index)}"

  + aws_route_table_association.Private_RT_IG[1]
      id:                                          <computed>
      route_table_id:                              "${aws_route_table.Private_RT.id}"
      subnet_id:                                   "${element(aws_subnet.privatesubnet.*.id, count.index)}"

  + aws_route_table_association.Public_RT_IG[0]
      id:                                          <computed>
      route_table_id:                              "${aws_route_table.Public_RT.id}"
      subnet_id:                                   "${element(aws_subnet.publicsubnet.*.id, count.index)}"

  + aws_route_table_association.Public_RT_IG[1]
      id:                                          <computed>
      route_table_id:                              "${aws_route_table.Public_RT.id}"
      subnet_id:                                   "${element(aws_subnet.publicsubnet.*.id, count.index)}"

  + aws_subnet.privatesubnet[0]
      id:                                          <computed>
      assign_ipv6_address_on_creation:             "false"
      availability_zone:                           "ap-south-1a"
      cidr_block:                                  "10.10.4.0/24"
      ipv6_cidr_block:                             <computed>
      ipv6_cidr_block_association_id:              <computed>
      map_public_ip_on_launch:                     "false"
      tags.%:                                      "1"
      tags.Name:                                   "private subnets tf"
      vpc_id:                                      "${aws_vpc.test_vpc.id}"

  + aws_subnet.privatesubnet[1]
      id:                                          <computed>
      assign_ipv6_address_on_creation:             "false"
      availability_zone:                           "ap-south-1b"
      cidr_block:                                  "10.10.5.0/24"
      ipv6_cidr_block:                             <computed>
      ipv6_cidr_block_association_id:              <computed>
      map_public_ip_on_launch:                     "false"
      tags.%:                                      "1"
      tags.Name:                                   "private subnets tf"
      vpc_id:                                      "${aws_vpc.test_vpc.id}"

  + aws_subnet.publicsubnet[0]
      id:                                          <computed>
      assign_ipv6_address_on_creation:             "false"
      availability_zone:                           "ap-south-1a"
      cidr_block:                                  "10.10.0.0/24"
      ipv6_cidr_block:                             <computed>
      ipv6_cidr_block_association_id:              <computed>
      map_public_ip_on_launch:                     "false"
      tags.%:                                      "1"
      tags.Name:                                   "public subnets tf"
      vpc_id:                                      "${aws_vpc.test_vpc.id}

  + aws_subnet.publicsubnet[1]
      id:                                          <computed>
      assign_ipv6_address_on_creation:             "false"
      availability_zone:                           "ap-south-1b"
      cidr_block:                                  "10.10.1.0/24"
      ipv6_cidr_block:                             <computed>
      ipv6_cidr_block_association_id:              <computed>
      map_public_ip_on_launch:                     "false"
      tags.%:                                      "1"
      tags.Name:                                   "public subnets tf"
      vpc_id:                                      "${aws_vpc.test_vpc.id}"

  + aws_vpc.test_vpc
      id:                                          <computed>
      assign_generated_ipv6_cidr_block:            "false"
      cidr_block:                                  "10.10.0.0/16"
      default_network_acl_id:                      <computed>
      default_route_table_id:                      <computed>
      default_security_group_id:                   <computed>
      dhcp_options_id:                             <computed>
      enable_classiclink:                          <computed>
      enable_classiclink_dns_support:              <computed>
      enable_dns_hostnames:                        <computed>
      enable_dns_support:                          "true"
      instance_tenancy:                            <computed>
      ipv6_association_id:                         <computed>
      ipv6_cidr_block:                             <computed>
      main_route_table_id:                         <computed>
      tags.%:                                      "1"
      tags.Name:                                   "test-vpc-terraform"


Plan: 14 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.test_vpc: Creating...
  assign_generated_ipv6_cidr_block: "" => "false"
  cidr_block:                       "" => "10.10.0.0/16"
  default_network_acl_id:           "" => "<computed>"
  default_route_table_id:           "" => "<computed>"
  default_security_group_id:        "" => "<computed>"
  dhcp_options_id:                  "" => "<computed>"
  enable_classiclink:               "" => "<computed>"
  enable_classiclink_dns_support:   "" => "<computed>"
  enable_dns_hostnames:             "" => "<computed>"
  enable_dns_support:               "" => "true"
  instance_tenancy:                 "" => "<computed>"
  ipv6_association_id:              "" => "<computed>"
  ipv6_cidr_block:                  "" => "<computed>"
  main_route_table_id:              "" => "<computed>"
  tags.%:                           "" => "1"
  tags.Name:                        "" => "test-vpc-terraform"
aws_vpc.test_vpc: Creation complete after 1s (ID: vpc-0a8a2fd29ed80380a)
aws_subnet.privatesubnet[1]: Creating...
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "ap-south-1b"
  cidr_block:                      "" => "10.10.5.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "false"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "private subnets tf"
  vpc_id:                          "" => "vpc-0a8a2fd29ed80380a"
aws_subnet.publicsubnet[0]: Creating...
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "ap-south-1a"
  cidr_block:                      "" => "10.10.0.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "false"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "public subnets tf"
  vpc_id:                          "" => "vpc-0a8a2fd29ed80380a"
aws_internet_gateway.IGW: Creating...
  vpc_id: "" => "vpc-0a8a2fd29ed80380a"
aws_subnet.privatesubnet[0]: Creating...
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "ap-south-1a"
  cidr_block:                      "" => "10.10.4.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "false"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "private subnets tf"
  vpc_id:                          "" => "vpc-0a8a2fd29ed80380a"
aws_subnet.publicsubnet[1]: Creating...
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "ap-south-1b"
  cidr_block:                      "" => "10.10.1.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "false"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "public subnets tf"
  vpc_id:                          "" => "vpc-0a8a2fd29ed80380a"
aws_internet_gateway.IGW: Creation complete after 0s (ID: igw-0ef30628a666be266)
aws_eip.eip_nat: Creating...
  allocation_id:     "" => "<computed>"
  association_id:    "" => "<computed>"
  domain:            "" => "<computed>"
  instance:          "" => "<computed>"
  network_interface: "" => "<computed>"
  private_ip:        "" => "<computed>"
  public_ip:         "" => "<computed>"
  vpc:               "" => "true"
aws_route_table.Public_RT: Creating...
  propagating_vgws.#:                         "" => "<computed>"
  route.#:                                    "" => "1"
  route.1808458864.cidr_block:                "" => "0.0.0.0/0"
  route.1808458864.egress_only_gateway_id:    "" => ""
  route.1808458864.gateway_id:                "" => "igw-0ef30628a666be266"
  route.1808458864.instance_id:               "" => ""
  route.1808458864.ipv6_cidr_block:           "" => ""
  route.1808458864.nat_gateway_id:            "" => ""
  route.1808458864.network_interface_id:      "" => ""
  route.1808458864.vpc_peering_connection_id: "" => ""
  vpc_id:                                     "" => "vpc-0a8a2fd29ed80380a"
aws_eip.eip_nat: Creation complete after 0s (ID: eipalloc-0a0236694b1b31d6e)
aws_route_table.Public_RT: Creation complete after 0s (ID: rtb-01a21b33a7afecba9)
aws_subnet.publicsubnet[1]: Creation complete after 0s (ID: subnet-06274a8ab8b48c276)
aws_subnet.privatesubnet[1]: Creation complete after 0s (ID: subnet-00f5cafb1a40703fc)
aws_subnet.privatesubnet[0]: Creation complete after 0s (ID: subnet-09208871a8d590678)
aws_subnet.publicsubnet[0]: Creation complete after 0s (ID: subnet-0278956a520df22eb)
aws_route_table_association.Public_RT_IG[0]: Creating...
  route_table_id: "" => "rtb-01a21b33a7afecba9"
  subnet_id:      "" => "subnet-0278956a520df22eb"
aws_route_table_association.Public_RT_IG[1]: Creating...
  route_table_id: "" => "rtb-01a21b33a7afecba9"
  subnet_id:      "" => "subnet-06274a8ab8b48c276"
aws_nat_gateway.NAT_GW: Creating...
  allocation_id:        "" => "eipalloc-0a0236694b1b31d6e"
  network_interface_id: "" => "<computed>"
  private_ip:           "" => "<computed>"
  public_ip:            "" => "<computed>"
  subnet_id:            "" => "subnet-0278956a520df22eb"
  tags.%:               "" => "1"
  tags.Name:            "" => "Nat Gateway"
aws_route_table_association.Public_RT_IG[1]: Creation complete after 0s (ID: rtbassoc-00274051090b15939)
aws_route_table_association.Public_RT_IG[0]: Creation complete after 0s (ID: rtbassoc-0f77629ca0c6e55fe)
aws_nat_gateway.NAT_GW: Still creating... (10s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (20s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (30s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (40s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (50s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (1m0s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (1m10s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (1m20s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (1m30s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (1m40s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (1m50s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (2m0s elapsed)
aws_nat_gateway.NAT_GW: Still creating... (2m10s elapsed)
aws_nat_gateway.NAT_GW: Creation complete after 2m15s (ID: nat-0ddc9aaf087261b09)
aws_route_table.Private_RT: Creating...
  propagating_vgws.#:                         "" => "<computed>"
  route.#:                                    "" => "1"
  route.3614424501.cidr_block:                "" => "0.0.0.0/0"
  route.3614424501.egress_only_gateway_id:    "" => ""
  route.3614424501.gateway_id:                "" => "nat-0ddc9aaf087261b09"
  route.3614424501.instance_id:               "" => ""
  route.3614424501.ipv6_cidr_block:           "" => ""
  route.3614424501.nat_gateway_id:            "" => ""
  route.3614424501.network_interface_id:      "" => ""
  route.3614424501.vpc_peering_connection_id: "" => ""
  vpc_id:                                     "" => "vpc-0a8a2fd29ed80380a"
aws_route_table.Private_RT: Creation complete after 1s (ID: rtb-0660bfaca2a37a17e)
aws_route_table_association.Private_RT_IG[1]: Creating...
  route_table_id: "" => "rtb-0660bfaca2a37a17e"
  subnet_id:      "" => "subnet-00f5cafb1a40703fc"
aws_route_table_association.Private_RT_IG[0]: Creating...
  route_table_id: "" => "rtb-0660bfaca2a37a17e"
  subnet_id:      "" => "subnet-09208871a8d590678"
aws_route_table_association.Private_RT_IG[1]: Creation complete after 0s (ID: rtbassoc-06f441e248d35acc2)
aws_route_table_association.Private_RT_IG[0]: Creation complete after 0s (ID: rtbassoc-09346823075786182)

Apply complete! Resources: 14 added, 0 changed, 0 destroyed.


Terraform Output
Outputs:

NAT Gateway = nat-0c4481f276630617b
internet gateway = igw-0a37738225c77c902
private route table = rtb-023fee097ded4d953
private subnet ids = [
    subnet-0ffc71fb7c19bfe97,
    subnet-0173872eaae3aed4b
]
public route table = rtb-05c60aa3be7f16ffc
public subnet ids = [
    subnet-07d68ca037e9b0f67,
    subnet-05464638048c20e90
]
vpc id = vpc-0e973310601537af9


Cheat Sheet

terraform init	Initialize a Terraform working directory
terraform plan	Generate and show an execution plan
terraform show	Inspect Terraform state and plan
terraform apply	Builds or changes infrastructure 
terraform destroy	Destroy terraform-managed infrastructure
terraform output	Read an output from a state file
