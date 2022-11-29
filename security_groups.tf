#security group for instances
resource "aws_security_group" "custom-security-group-inst" {
    name = "custom-security-group-inst"
    description = "Security group for instances."
    vpc_id = aws_vpc.customvpc.id

    ingress {
        security_groups = [ aws_security_group.custom-security-group-elb.id ]
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "0"
        to_port = "0"
        protocol = "-1"
    }
}

#security group for aws ELB
resource "aws_security_group" "custom-security-group-elb" {
    name = "custom-security-group-elb"
    description = "Security group for ALB."
    vpc_id = aws_vpc.customvpc.id

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "0"
        to_port = "0"
        protocol = "-1"
    }
    tags = {
      "Name" = "custom-security-group-elb"
    }
}
