include {
    path= find_in_parent_folders()
}
terraform {
    # source = "../network"
    source ="git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//network?ref=v0.0.10"
}

inputs = { 
    name = "network"
}