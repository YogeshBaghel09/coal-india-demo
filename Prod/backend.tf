terraform {
  backend "s3" {
    bucket = "coal-india-demo-s3-bucket"
    #dynamodb_table = "s3-terraform-eks-state-lock"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

