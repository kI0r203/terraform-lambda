module "VotingFunction" {
  source = "../lambda"
  function_name = "VotingFunction-3"
  handler = "vote_counter.handler"
  infra_bucket = "deploy-upb-bucket"
  package_key_location = "lambda/VotingFunction.zip"
  extra_policy_arns = [module.VotingFunction.arn_policy_s3]
  env_vars = {"CollectorBucket" = "collector-bucket-nicolas-1"
              "ResultBucket" = "results-bucket-nicolas-1"}
  results_bucket = "results-bucket-nicolas-1"
  collector_bucket = "collector-bucket-nicolas-1"
}