resource "aws_instance" "server" {
    ami             = var.windows-ami[var.region_list[2]]
    instance_type   = "t2.micro"
    key_name        = "terraform" # Change key Name
    tags = {
        Name = "TF-Windows-Server"
    }

}

resource "aws_vpc" "vpc-1" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "tf-vpc"
    }
  
}

resource "aws_subnet" "subnet-1" {
    vpc_id      = aws_vpc.vpc-1.id
    cidr_block  = "10.0.0.0/24"
    map_public_ip_on_launch = true
    depends_on = [aws_internet_gateway.gateway]
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.vpc-1.id
  
}

resource "aws_security_group" "allow_traffic" {
    name        = "rdp_traffic"
    description = "allow traffic from rdp"
    vpc_id      = aws_vpc.vpc-1.id
    ingress {
        description = "RDP"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Allow RDP"
    }
  
}

resource "aws_network_interface" "server-nif" {
    subnet_id = aws_subnet.subnet-1.id
    private_ip = "10.0.0.25"
    security_groups = [aws_security_group.allow_traffic.id]
  
}

resource "aws_eip" "eip" {
    vpc = true
    instance = "${aws_instance.server.id}"
    network_interface = aws_network_interface.server-nif.id
    depends_on = [aws_internet_gateway.gateway]
  
}
