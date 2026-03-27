resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true


  tags = {
    Name = "Jenkins Bucket"
  }
}

resource "aws_s3_object" "object-txt" {
  bucket = aws_s3_bucket.frontend.id
  key    = "github-webhook/armageddon-link.txt"
  source = "${path.module}/github-webhook/armageddon-link.txt"
}

resource "aws_s3_object" "object-png" {
  bucket = aws_s3_bucket.frontend.id
  key    = "github-webhook/pass-proof.png"
  source = "${path.module}/github-webhook/pass-proof.png"
}