locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//cloudflare?ref=v0.0.5"
}

inputs = {
  subdomain = local.env.locals.www_frontend_subdomain
  cname     = dependency.website-cloudflare.outputs.endpoint
  proxied   = local.env.locals.www_frontend_proxied
  name = "website-cloudflare-www"
}

dependency "website-cloudflare" {
  config_path = "../website-cloudflare"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    endpoint = "mock.website.cname"
  }
}
