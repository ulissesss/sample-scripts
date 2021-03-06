variable "secret_key" {
    description = "aws secret key"
}

variable "access_key" {
    description = "aws secret key"
}

variable "region_list" {
    description = "us-east-1/2 and us-west-1/2 are available"
    type    = list(string)
    default = [
        "us-east-1",
        "us-east-2",
        "us-west-1",
        "us-west-2"
    ]
    
}

variable "windows-ami" {
    description = "Windows Machine Image"
    type     = map(string)
    default  = {

        us-east-1 = "ami-0229f7666f517b31e"
        us-east-2 = "ami-0d5b55fd8cd8738f5"
        us-west-1 = "ami-0b7c10374cfb013e6"
        us-west-2 = "ami-0706901be27b0d22b"

    }
}

variable "linux-ami" {
    description = "linux Machine Images"
    type    = map(string)
    default = {

        us-east-1 = "ami-0be2609ba883822ec"
        us-east-2 = "ami-0a0ad6b70e61be944"
        us-west-1 = "ami-03130878b60947df3"
        us-west-2 = "ami-0a36eb8fadc976275"

    }
}