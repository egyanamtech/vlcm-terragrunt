locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
include {
  path   = find_in_parent_folders()
  expose = true
}
terraform {
  # source = "../website-s3"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//website-s3?ref=v0.0.16"
}

inputs = {
  # allowed_origins = ["https://api.${include.site_domain}"]
  allowed_origins = local.env.locals.allowed_origins
  name = "website-s3"

}
