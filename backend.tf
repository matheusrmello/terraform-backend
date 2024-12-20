terraform {
  backend "s3" {
    bucket         = "test-matheus-tfstate"
    key            = "backend/tfstate"
    # dynamodb_table = "test-matheus-terraform-state-backend"
    region         = "us-east-2"
  }
}