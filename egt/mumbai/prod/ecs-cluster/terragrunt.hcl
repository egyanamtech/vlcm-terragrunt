locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
include {
  path = find_in_parent_folders()
}
terraform {
  # source = "../ecs-cluster"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//ecs-cluster?ref=v0.0.12"
}

inputs = {
  cluster_name = local.env.locals.ecs_cluster_name
  name = "ecs-cluster"
}
