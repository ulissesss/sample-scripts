
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment


# Creating a tgw take little over a miniute
resource "aws_ec2_transit_gateway" "tgw" {  
    description = "tgw example"
    auto_accept_shared_attachments = "enable"
    tags = {
        name = "tf-tgw"
    }
  
}

# vpc attachment take a minute
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = [aws_subnet.subnet-1.id] # list of strings
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc-1.id
}