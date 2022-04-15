locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
include {
  path = find_in_parent_folders()
}
terraform {
  # source = "../s3"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//s3?ref=v0.0.17"
}

inputs = {
  bucket_prefix = local.env.locals.upload_bucket_prefix
  name = "s3-upload-bucket"
}
