locals {
  common = read_terragrunt_config(find_in_parent_folders("common.terragrunt.hcl"))
  account = read_terragrunt_config(find_in_parent_folders("account.terragrunt.hcl"))
  region = read_terragrunt_config(find_in_parent_folders("region.terragrunt.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt         = true
    region          = local.region.locals.aws_region
    bucket          = "${local.common.locals.app_name}-${local.account.locals.aws_account_id}-tfstate"
    key             = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table  = "${local.common.locals.app_name}-${local.account.locals.aws_account_id}-lock"
    profile         =  local.account.locals.aws_profile
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region.locals.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account.locals.aws_account_id}"]
  profile = "${local.account.locals.aws_profile}"
}
EOF
}


# Generate an AWS provider block
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

inputs = merge(
  local.common.locals,
  local.account.locals,
  local.region.locals,
  local.environment.locals
)

### Old one
# remote_state {
#   backend = "s3"
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
#   config = {
#     bucket         = local.bucket_name
#     key            = "${local.env}/terraform.tfstate"
#     region         = local.aws_region
#     encrypt        = true
#     profile        = local.profile
#     dynamodb_table = local.lock_table
#   }
# }
# generate "provider" {
#   path      = "provider.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region  = "${local.aws_region}"
#   profile = "${local.profile}"
# }
# EOF
# }
