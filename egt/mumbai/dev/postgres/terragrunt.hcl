include {
  path = find_in_parent_folders()
}
terraform {
  # source = "../postgres"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//postgres?ref=v0.0.8"
}

inputs = {
  vpc_cidr_block  = dependency.network.outputs.vpc_cidr
  vpc_id          = dependency.network.outputs.vpc_id
  db_subnet_group = dependency.network.outputs.database_subnet_group
  name = "postgres"
}

dependency "network" {
  config_path = "../network"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    vpc_id                = "mock_vpc_id"
    vpc_cidr              = "127.0.0.1/32"
    database_subnet_group = "mock_database_subnet_group"
  }
}
