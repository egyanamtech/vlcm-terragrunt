locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}

include {
  path = find_in_parent_folders()
}
terraform {
  # source = "../cloudflare"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//cloudflare?ref=v0.0.6"
}

inputs = {
  subdomain = local.env.locals.api_subdomain
  cname     = dependency.alb.outputs.alb_dns_name
  proxied   = local.env.locals.api_proxied
  name = "api-cloudflare"
  cloudflare_gh_name = local.env.locals.api_cloudflare_secret_name
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    alb_dns_name = "mock.alb.dns"
  }
}
