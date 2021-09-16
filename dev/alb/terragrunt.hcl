
include {
    path= find_in_parent_folders()
}
terraform {
    # source = "../alb"
    source ="git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//alb?ref=v0.0.2"
}

inputs = {
    public_subnets = dependency.network.outputs.public_subnets
    vpc_id = dependency.network.outputs.vpc_id
    vpc_cidr_block = dependency.network.outputs.vpc_cidr
}

dependency "network" {
    config_path = "../network"

    mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

    mock_outputs = {
        public_subnets = ["mock_public_subnet_1", "mock_public_subnet_2"]
        vpc_id = "mock_vpc_id"
        vpc_cidr = "127.0.0.1/32"
    }
}
