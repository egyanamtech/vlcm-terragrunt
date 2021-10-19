include {
    path= find_in_parent_folders()
}
terraform {
    # source = "../cloudflare"
    source ="git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//cloudflare?ref=v0.0.3"
}

inputs = {
    subdomain = ""
    cname = dependency.website-s3.outputs.s3_website_cname
    proxied = true
}

dependency "website-s3" {
    config_path = "../website-s3"

    mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

    mock_outputs = {
        s3_website_cname = "mock.s3-website.cname"
    }
}