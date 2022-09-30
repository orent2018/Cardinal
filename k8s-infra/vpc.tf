# Get all AZs
data "aws_availability_zones" "available" {}

#Create the VPC
resource "aws_vpc" "CardinalVPC" {         # Creating VPC here
  cidr_block           = var.main_vpc_cidr # Defining the CIDR block use 10.0.0.0/24 for demo
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "CardinalVPC"
  }
}
# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" { # Creating the Internet Gateway
  vpc_id = aws_vpc.CardinalVPC.id
}
# Create a Public Subnet.
resource "aws_subnet" "CardinalPubSubnet" { # Creating Public Subnet
  vpc_id     = aws_vpc.CardinalVPC.id
  cidr_block = var.public_subnet # CIDR block of public subnets
}
# Create a Private Subnet 1                    # Creating Private Subnets
resource "aws_subnet" "CardinalPrvSubnet1" {
  vpc_id            = aws_vpc.CardinalVPC.id
  cidr_block        = var.private_subnet1 # CIDR block of private subnet1
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "PrivateSubnet1"
  }
}
# Create a Private Subnet 2                   
resource "aws_subnet" "CardinalPrvSubnet2" {
  vpc_id            = aws_vpc.CardinalVPC.id
  cidr_block        = var.private_subnet2 # CIDR block of private subnet2
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "PrivateSubnet2"
  }
}
# Route table for Public Subnet's
resource "aws_route_table" "PublicRT" { # Creating RT for Public Subnet
  vpc_id = aws_vpc.CardinalVPC.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}
# Route table for Private Subnet's
resource "aws_route_table" "PrivateRT" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.CardinalVPC.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.CardinalNATgw.id
  }
}
# Route table Association with Public Subnet's
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.CardinalPubSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}
# Route table Association with Private Subnet 1
resource "aws_route_table_association" "PrivateRTassociation1" {
  subnet_id      = aws_subnet.CardinalPrvSubnet1.id
  route_table_id = aws_route_table.PrivateRT.id
}
# Route table Association with Private Subnet 2
resource "aws_route_table_association" "PrivateRTassociation2" {
  subnet_id      = aws_subnet.CardinalPrvSubnet2.id
  route_table_id = aws_route_table.PrivateRT.id
}
resource "aws_eip" "natIP" {
  vpc = true
}
# Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "CardinalNATgw" {
  allocation_id = aws_eip.natIP.id
  subnet_id     = aws_subnet.CardinalPubSubnet.id
}
