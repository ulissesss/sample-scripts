# variable "new_ubuntu_1804_ami" {}
variable "itsec-key" {default = "itsec-shared"}


resource "aws_instance" "jamf-dev" {
  ami                     = var.new_ubuntu_1804_ami
  instance_type           = "c5.xlarge"
  subnet_id               = aws_subnet.private_1a.id
  key_name                = var.itsec-key
  ebs_optimized           = true
  vpc_security_group_ids  = [
    aws_security_group.jamfdev-sg.id,
  ]
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = true
  }
  tags = {
    Name        = "jamf-dev"
    Provisioned = "terraform"
    Type        = "IT-Managed-Jamf-Dev"
  }
}

#KMS Key for Jamf-Dev
resource "aws_kms_key" "jamfdev-ebs-key" {
  description             = "jamfdev-ebs-key"
}

##### EBS Volumes for Jamfdev  #####
resource "aws_ebs_volume" "jamfdev-ebs" {
  availability_zone = "eu-west-1a"
  type              = "gp2"
  encrypted         = true
  kms_key_id        = aws_kms_key.jamfdev-ebs-key.arn
  size              = 100
  tags = {
    Name = "Jamfdev-Ebs"
  }
}

resource "aws_volume_attachment" "jamfdev-attachment-ebs" {
  device_name = "xvdb"
  volume_id   = aws_ebs_volume.jamfdev-ebs.id
  instance_id = aws_instance.jamf-dev.id
}

##### Security Groups #####
resource "aws_security_group" "jamfdev-sg" {
  vpc_id = aws_vpc.default.id
  name   = "jamfdev-sg"
}

resource "aws_security_group_rule" "jamfdev" {
  type              = "ingress"
  from_port         = 22 
  to_port           = 22
  protocol          = "tcp"
  description       = "SSH"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.jamfdev-sg.id
}

resource "aws_security_group_rule" "jamf-checkin" {
  type              = "ingress"
  from_port         = 8443 
  to_port           = 8443
  protocol          = "tcp"
  description       = "JAMF"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jamfcheckin-sg.id
}

resource "aws_security_group_rule" "jamfdev-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "allow any egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.revserver-sg.id
}
