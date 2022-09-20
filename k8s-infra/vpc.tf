#Create the VPC
resource "aws_vpc" "CardinalVPC" {     # Creating VPC here
  cidr_block       = var.main_vpc_cidr # Defining the CIDR block use 10.0.0.0/24 for demo
  instance_tenancy = "default"
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
# Create a Private Subnet                   # Creating Private Subnets
resource "aws_subnet" "CardinalPrvSubnet" {
  vpc_id     = aws_vpc.CardinalVPC.id
  cidr_block = var.private_subnet # CIDR block of private subnets
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
# Route table Association with Private Subnet's
resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.CardinalPrvSubnet.id
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
