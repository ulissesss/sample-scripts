variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "us-west-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-west-1 = "ami-00831fc7c1e3ddc60"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "tf-ubuntu"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "tf-ubuntu.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
