terraform {
  backend "s3" {
    bucket         = "test-matheus-tfstate"
    key            = "test/tfstate"
    dynamodb_table = "matheus-terraform-state"
    region         = "us-east-2"
  }
}
