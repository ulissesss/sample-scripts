provider "aws" {
}

resource "aws_sns_topic" "aws_sns_topic" {
  name = "glacier-sns-topic"
}

output "sns" {
  value = aws_sns_topic.aws_sns_topic.arn
}

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
          "Resource": "arn:aws:glacier:us-west-1:564292328108:vaults/DepartedEmp"
       }
    ]
}
EOF
#TODO:  Change "rescource" to aws_sns_topic [Different for every user]

  tags = {
    Archive = "DepartedEmp"
  }
}
