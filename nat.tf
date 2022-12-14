#Define external IP - NAT Gateway - use NAT gateway for EC2
#in a private VPC subnet to conect securely over the internet
resource "aws_eip" "customvpc-nat" {
    vpc = true
}

resource "aws_nat_gateway" "customvpc-nat-gw" {
    allocation_id = aws_eip.customvpc-nat.id
    subnet_id = aws_subnet.customvpc-public-1.id
    depends_on = [ aws_internet_gateway.customvpc-gw ]
}

resource "aws_route_table" "customvpc-private-rt" {
    vpc_id = aws_vpc.customvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.customvpc-nat-gw.id
    }
    tags = {
      "Name" = "customvpc-private-rt"
    }
}

#route association private
resource "aws_route_table_association" "customvpc-private-rta" {
    subnet_id = aws_subnet.customvpc-private-1.id
    route_table_id = aws_route_table.customvpc-private-rt.id 
}