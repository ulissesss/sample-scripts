resource "aws_instance" "server" {
    ami             = "t2.micro"
    instance_type   = var.windows-ami[var.region_list[3]]
    key_name        = "terraform" # Change key Name
    tags = {
        Name = "TF-${terraform.workspace}-Server"
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
    cidr_block  = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.vpc-1.id
  
}

resource "aws_security_group" "allow_traffic" {
    name        = "ssh_traffic"
    description = "allow traffic from ssh"
    vpc_id      = aws_vpc.vpc-1.id
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
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
        Name = "Allow SSH"
    }
  
}

resource "aws_network_interface" "server-nif" {
    subnet_id = aws_subnet.subnet-1.id
    private_ip = "10.0.1.25"
    security_groups = [aws_security_group.allow_traffic.id]
  
}

resource "aws_eip" "linux-eip" {
    vpc = true
    network_interface = aws_network_interface.server-nif.id
    associate_with_private_ip = "10.0.1.25"
    depends_on = [aws_internet_gateway.gateway]
  
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment

resource "aws_ec2_transit_gateway" "tgw" {
  
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = [aws_subnet.subnet-1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc-1.id
}