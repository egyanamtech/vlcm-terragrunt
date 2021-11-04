include {
    path= find_in_parent_folders()
}
terraform {
    # source = "../redis"
    source ="git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//redis?ref=v0.0.4"
}

inputs = {
    vpc_cidr_block = dependency.network.outputs.vpc_cidr
    vpc_id = dependency.network.outputs.vpc_id
    redis_subnet_group = dependency.network.outputs.elasticache_subnet_group
    redis_node_count = 1
    redis_instance_size = "cache.t2.micro"
    name = "redis"
}

dependency "network" {
    config_path = "../network"

    mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

    mock_outputs = {
        vpc_id = "mock_vpc_id"
        vpc_cidr = "127.0.0.1/32"
        elasticache_subnet_group = "mock_redis_subnet_group"
    }
}