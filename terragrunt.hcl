locals {
  env         = path_relative_to_include()
  bucket_name = "vlcm-svc-bootstrap"
  profile     = "msyt1969__terraform"
  kms_key     = "ed16e441-a506-4553-8d36-710baaabe11d"
  lock_table  = "vlcm-svc-bootstrap-lock"
  aws_region  = "ap-south-1"
  repository_url = {
    "backend"    = "261508060912.dkr.ecr.ap-south-1.amazonaws.com/vlcm-backend",
    "nginx"  = "261508060912.dkr.ecr.ap-south-1.amazonaws.com/vlcm-nginx",
  }
  cert_arn = "arn:aws:acm:ap-south-1:261508060912:certificate/6f95efaa-bf92-47c4-8c93-2e69d38b790a"
  site_domain = "imparham.in"
  aws_account_id = "261508060912"
}

inputs = {
  aws_region     = local.aws_region
  namespace      = "vlcm"
  stage          = split("/", local.env)[0]
  name           = split("/", local.env)[1]
  aws_profile    = local.profile
  repository_url = local.repository_url
  cert_arn = local.cert_arn
  site_domain = local.site_domain
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
