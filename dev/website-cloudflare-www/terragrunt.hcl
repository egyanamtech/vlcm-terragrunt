include {
    path= find_in_parent_folders()
}
terraform {
    source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//cloudflare?ref=v0.0.2"
}

inputs = {
    subdomain = "www"
    cname = dependency.website-cloudflare.outputs.endpoint
    proxied = true
}

dependency "website-cloudflare" {
    config_path = "../website-cloudflare"

    mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

    mock_outputs = {
        endpoint = "mock.website.cname"
    }
}