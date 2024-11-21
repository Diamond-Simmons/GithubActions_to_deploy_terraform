provider "aws" {
  region = "us-west-2" #Provide your own AWS Region
}

terraform {
  backend "s3" {
    bucket = "diamond-terraform-gitactions" #Make sure to create your S3 bucket first!
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Diamond-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id 
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a" #Your availability is based on your region
  map_public_ip_on_launch = true
  tags = {
    Name = "Diamond-PublicSubnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Diamond-IGW"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Diamond-routeTable"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Diamond-SecurityGroup"
  }
}



resource "aws_instance" "my_ec2" {
  ami                    = "ami-04dd23e62ed049936" #Provide the AMI that you would like to use
  instance_type          = "t2.micro" #Provide the instance type that you would like to use
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    Name = "Diamond-Ec2Instance"
  }
}

