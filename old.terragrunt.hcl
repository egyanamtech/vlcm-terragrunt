locals {
  # env         = path_relative_to_include()
  # bucket_name = "vlcm-svc-bootstrap"
  # profile     = "msyt1969__terraform"
  # I think kms_key is not being used
  # I think we can safely remove this
  #  kms_key     = "054d0880-eabc-42b9-ae5d-b4cdd7bbfc3b"
  # lock_table  = "vlcm-svc-bootstrap-lock"
  # aws_region  = "ap-south-1"
  repository_url = {
    "backend" = "261508060912.dkr.ecr.ap-south-1.amazonaws.com/vlcm-backend",
    "nginx"   = "261508060912.dkr.ecr.ap-south-1.amazonaws.com/vlcm-nginx",
  }
  cert_arn = "arn:aws:acm:ap-south-1:261508060912:certificate/12677175-3a05-4fe4-b51a-9c1e930bb6b2"
  # site_domain = "imparham.in"
  # aws_account_id = "261508060912"
}

inputs = {
  aws_region     = local.aws_region
  namespace      = "vlcm"
  stage          = split("/", local.env)[0]
  name           = split("/", local.env)[1]
  aws_profile    = local.profile
  repository_url = local.repository_url
  cert_arn       = local.cert_arn
  site_domain    = local.site_domain
  aws_account_id = local.aws_account_id
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.bucket_name
    key            = "${local.env}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    profile        = local.profile
    dynamodb_table = local.lock_table
  }
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.aws_region}"
  profile = "${local.profile}"
}
EOF
}
