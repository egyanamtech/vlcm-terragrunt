locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
include {
  path = find_in_parent_folders()
}
terraform {
  # source = "../bastion"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//bastion?ref=v0.0.8"
}

inputs = {
  name = "bastion"
  vpc_id          = dependency.network.outputs.vpc_id
  subnet_id = dependency.network.outputs.public_subnets[0]
  key_name = local.env.locals.key_name
  account_id = local.account.locals.aws_account_id
  aws_region     = local.region.locals.aws_region
}
dependency "network" {
  config_path = "../network"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    vpc_id                = "mock_vpc_id"
    public_subnets = ["mock_subnet_id_1", "mock_subnet_id_2"]
  }
}