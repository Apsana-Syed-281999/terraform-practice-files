provider "aws" {
region = "us-east-1"  
}



resource "aws_vpc" "myVpc" {
tags = {
Name = "terra-vpc"
}
cidr_block = "3.0.0.0/18"
instance_tenancy = "default"
enable_dns_hostnames = "true"
}

resource "aws_subnet" "mySNPub" {
vpc_id = aws_vpc.myVpc.id
tags = {
Name = "Terra-SN-Pub"
}
cidr_block = "3.0.0.0/24"
availability_zone = "us-east-1a"
map_public_ip_on_launch = "true"
}

resource "aws_subnet" "mySNPri" {
vpc_id = aws_vpc.myVpc.id
tags = {
Name = "Terra-SN-Pri"
}
cidr_block = "3.0.1.0/24"
availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "myIGW" {
vpc_id = aws_vpc.myVpc.id
tags = {
Name = "Terra-IGW"
}
}

resource "aws_nat_gateway" "myNATgw" {
vpc_id = aws_vpc.myVpc.id
tags = {
Name = "Terra-NATgw"
}
allocation_id = null
}

resource "aws_route_table" "myRTPub" {
vpc_id = aws_vpc.myVpc.id
tags = {
Name = "Terra-RT-Pub"
}
route{
gateway_id = aws_internet_gateway.myIGW.id
cidr_block = "0.0.0.0/0"
}
}

resource "aws_route_table" "myRTPri" {
vpc_id = aws_vpc.myVpc.id
tags = {
Name = "Terra-RT-Pri"
}
route {
nat_gateway_id = aws_nat_gateway.myNATgw.id
cidr_block = "0.0.0.0/0"
}
}

resource "aws_route_table_association" "myPub" {
subnet_id = aws_subnet.mySNPub.id
route_table_id = aws_route_table.myRTPub.id

}
resource "aws_route_table_association" "myPri" {
subnet_id = aws_subnet.mySNPri.id
route_table_id = aws_route_table.myRTPri.id
}
