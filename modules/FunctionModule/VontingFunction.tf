module "VotingFunction" {
  source = "../lambda"
  function_name = "VotingFunction-3"
  handler = "vote_function.lambda_handler"
  infra_bucket = "deploy-upb-bucket"
  package_key_location = "lambda/VotingFunction.zip"
  extra_policy_arns = [module.VotingFunction.arn_policy_s3]
  env_vars = {"CollectorBucket" = "results-bucket-nicolas-1"
              "ResultBucket" = "collector-bucket-nicolas-1"}
  results_bucket = "results-bucket-nicolas-1"
  collector_bucket = "collector-bucket-nicolas-1"
}