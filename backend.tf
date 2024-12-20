terraform {
  backend "s3" {
    bucket         = "test-matheus-tfstate"
    key            = "backend/tfstate"
    dynamodb_table = "test-matheus-terraform-state-backend"
    region         = "us-east-2"
  }
}

# resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#   name           = "test-matheus-terraform-state"
#   hash_key       = "LockID"
#   read_capacity  = 20
#   write_capacity = 20

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#   tags = {
#     Name = "test-matheus-lock-table"
#   }
# }