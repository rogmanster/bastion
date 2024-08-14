# Allocate Elastic IP. (This EIP will be used for the Nat-Gateway in the Public Subnet AZ1)
resource "aws_eip" "eip_for_nat_gateway_az1" {
  #domain    = "vpc"

  tags   = {
    Name = "Nat Gateway AZ1 EIP"
  }
}

# Create Nat Gateway in Public Subnet AZ1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  #subnet_id     = var.public_subnet_az1_id
  subnet_id     = aws_subnet.public.id 
  
  tags   = {
    Name = "Nat Gateway AZ1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  #depends_on = [var.internet_gateway]
}

# Create Private Route Table AZ1 and add route through Nat Gateway AZ1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "Private Route Table AZ1"
  }
}

# Associate Private Subnet AZ1 with Private Route Table AZ1
resource "aws_route_table_association" "private_subnet_az1_route_table_az1_association" {
  subnet_id         = aws_subnet.private.id
  route_table_id    = aws_route_table.private_route_table_az1.id
}
