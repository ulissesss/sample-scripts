provider "aws" {
  region = var.region
}

resource "aws_sns_topic" "aws_sns_topic" {
  name = "vaults"
}

output "sns" {
  value = "Rescource Key: arn:aws:glacier:${trimprefix(aws_sns_topic.aws_sns_topic.arn, "arn:aws:sns:")}/DepartedEmp"
}


#  arn:aws:sns:us-west-1:564292328108:vaults
#  us-west-1:564292328108:vaults
#  arn:aws:glacier: + us-west-1:564292328108:vaults + /DepartedEmp



resource "aws_glacier_vault" "departed_emp" {
  name = "DepartedEmp"

  notification {
    sns_topic = aws_sns_topic.aws_sns_topic.arn
    events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
  }

  access_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Sid": "add-read-only-perm",
          "Principal": "*",
          "Effect": "Allow",
          "Action": [
             "glacier:InitiateJob",
             "glacier:GetJobOutput"
          ],

          "Resource": "arn:aws:glacier:${trimprefix(aws_sns_topic.aws_sns_topic.arn, "arn:aws:sns:")}/DepartedEmp"
       }
    ]
}
EOF

  tags = {
    Archive = "DepartedEmp"
  }
}
