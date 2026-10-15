##### provider ######
provider "aws" {
region = "us-east-1"
}


##### instance resource #####
resource "aws_instance" "myInst" {
tags = {
Name = "Server1"
Environment = "Dev"
}
ami = "ami-004d1eaf8eaa0107d"
instance_type = "t3.micro"
key_name = "CICDkey"
vpc_security_group_ids = [aws_security_group.mySG.id]
availability_zone = "us-east-1a"
root_block_device{
volume_size = 10
}
}



##### security resource ###

resource "aws_security_group" "mySG"{
name = "Terra-sG"
description = "This security group is created using terraform and will be attached to Server1"

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 8080
to_port = 8081
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}
