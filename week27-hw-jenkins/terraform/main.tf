resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true

  tags = {
    Name = "Jenkins Bucket"
  }
}

resource "aws_s3_object" "uploads" {
  for_each = fileset("${path.module}/../armageddon-proof", "*")

  bucket = aws_s3_bucket.frontend.id
  key    = each.value
  source = "${path.module}/../armageddon-proof/${each.key}"

  depends_on = [aws_s3_bucket.frontend]
}

resource "aws_s3_bucket_public_access_block" "frontend_pab" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend_pab]
}

output "bucket_name" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.frontend.id
}

output "uploaded_files" {
  description = "List of uploaded S3 object keys"
  value       = [for f in aws_s3_object.uploads : f.key]
}