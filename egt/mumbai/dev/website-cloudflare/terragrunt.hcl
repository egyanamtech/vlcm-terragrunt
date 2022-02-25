locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
include {
  path = find_in_parent_folders()
}
terraform {
  # source = "../cloudflare"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//cloudflare?ref=v0.0.13"
}

inputs = {
  subdomain = local.env.locals.frontend_subdomain
  cname     = dependency.website-s3.outputs.s3_website_cname
  proxied   = local.env.locals.frontend_proxied
  name = "website-cloudflare"
}

dependency "website-s3" {
  config_path = "../website-s3"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    s3_website_cname = "mock.s3-website.cname"
  }
}
