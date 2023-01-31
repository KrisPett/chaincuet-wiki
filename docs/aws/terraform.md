#### S3 Static Website Hosting - Cloudfront - Route53
```
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "static-website-bucket"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

resource "aws_cloudfront_distribution" "static_website" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.static_website.bucket}"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.static_website.bucket}"

    forwarded_values {
      query_string = false
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  enabled = true

  aliases = [
    "www.example.com",
  ]
}

resource "aws_route53_record" "static_website" {
  zone_id = "ZXXXXXXXXXXXXX"
  name    = "example.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_website.domain_name
    zone_id               = aws_cloudfront_distribution.static_website.hosted_zone_id
    evaluate_target_health = true
  }
}

```