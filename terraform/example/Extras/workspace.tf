locals {
   env = {
      windows = {
         instance_type  = "t2.micro"
         ami            = {

            us-east-1 = "ami-0229f7666f517b31e"
            us-east-2 = "ami-0d5b55fd8cd8738f5"
            us-west-1 = "ami-0ae930fa924b34ed3"
            us-west-2 = "ami-0706901be27b0d22b"

         }
      }
      linux = {
         instance_type  = "t2.micro"
         ami            = {

            us-east-1 = "ami-0be2609ba883822ec"
            us-east-2 = "ami-0a0ad6b70e61be944"
            us-west-1 = "ami-03130878b60947df3"
            us-west-2 = "ami-0a36eb8fadc976275"
            
         }
      }
   }
   environmentvars = "${contains(keys(local.env), terraform.workspace) ? terraform.workspace : "linux"}"
   workspace       = "${merge(local.env["linux"], local.env[local.environmentvars])}"
}
