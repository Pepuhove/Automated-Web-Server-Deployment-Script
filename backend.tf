
terraform {
    backend "s3" {
        bucket = "pepu1214"
        key = "terraform/backend"
        region = "us-east-1"
    }
}