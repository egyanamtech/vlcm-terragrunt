include {
    path= find_in_parent_folders()
}
terraform {
    # source = "../ecs-cluster"
    source ="git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//ecs-cluster?ref=v0.0.2"
}

inputs = {
    cluster_name = "vlcm-cluster"
}
