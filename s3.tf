resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-devops2024"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
