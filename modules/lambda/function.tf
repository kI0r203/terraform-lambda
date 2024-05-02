resource "aws_lambda_function" "test_lambda" {
  s3_bucket = var.infra_bucket
  s3_key = var.package_key_location
  s3_object_version = data.aws_s3_object.lambda_code_object.version_id
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  timeout = 5

  runtime = "python3.12"

  environment {
    variables = var.env_vars
  }
}

data "aws_s3_object" "lambda_code_object" {
  bucket = var.infra_bucket
  key    = var.package_key_location
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.collector_bucket.arn
}

resource "aws_s3_bucket" "collector_bucket" {
  bucket = var.collector_bucket
}

resource "aws_s3_object" "collector_object" {
  bucket = aws_s3_bucket.collector_bucket.id
  key    = "votingResults/"
}


resource "aws_s3_object" "results_object" {
  bucket = aws_s3_bucket.results_bucket.id
  key    = "votingResults/"
}

resource "aws_s3_bucket" "results_bucket" {
  bucket = var.results_bucket
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.collector_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "votingResults/"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

