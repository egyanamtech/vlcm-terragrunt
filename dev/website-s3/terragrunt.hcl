include {
    path= find_in_parent_folders()
    expose = true
}
terraform {
    # source = "../website-s3"
    source ="git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//website-s3?ref=v0.0.1"
}

inputs = {
    # allowed_origins = ["https://api.${include.site_domain}"]
    allowed_origins = ["https://api.imparham.in"]
}
