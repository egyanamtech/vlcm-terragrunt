include {
    path= find_in_parent_folders()
}
terraform {
    # source = "../s3"
    source ="git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//s3?ref=v0.0.2"
}

inputs = {
    bucket_prefix = "vlcm-uploads"
}