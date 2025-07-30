resource "aws_s3_bucket" "myBucket" {
   bucket = "my-older-tutorial-demo-bucket"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc-1"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.2/24"

  tags = {
    Name = "my-public-subnet"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my-igw"
  }
}
resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id
  
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id

  }
}

resource "aws_route_table_association" "my-rt-sub-" {
  subnet_id = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "sg" {
  name = "my-sg-1"
  description = "allow TLS "
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP for VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "custom"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "my-sucure-g"
  }
}

resource "aws_instance" "my-instance" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.sg.id]
  subnet_id = aws_subnet.mysubnet.id
  associate_public_ip_address = true

  tags = {
    Name = "my-server"
  }
}