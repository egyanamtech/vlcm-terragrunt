# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  common  = read_terragrunt_config(find_in_parent_folders("common.terragrunt.hcl"))
  account = read_terragrunt_config(find_in_parent_folders("account.terragrunt.hcl"))
  region  = read_terragrunt_config(find_in_parent_folders("region.terragrunt.hcl"))
  

  # Configure environment
  environment = "dev"
  stage = local.environment

  site_domain = "imparham.in"
  site_prefix = "dev-"

  app_name       = local.common.locals.app_name
  aws_account_id = local.account.locals.aws_account_id
  aws_region     = local.region.locals.aws_region

  # THis is used in the ecs-service module, in the alb.tf file
  # For giving a SSL cert to the Load Balancer
  cert_prefix = "arn:aws:acm:${local.aws_region}:${local.aws_account_id}:certificate"
  cert_id     = "4ee26f4a-bd1c-4bb1-90f6-46aea02a72a6"

  cert_arn = "${local.cert_prefix}/${local.cert_id}"
  #   DB RELATED STUFF
  db_name           = "vlcm"
  db_username       = "postgres"
  db_multi_az       = false
  db_instance_size  = "db.t2.micro"
  db_allocated_size = 20
  db_max_size       = 100

  # REDIS RELATED STUFF
  redis_node_count    = 1
  redis_instance_size = "cache.t2.micro"

  # Cloudflare for backend API stuff
  api_proxied   = false
  api_subdomain = "${local.site_prefix}api"

  # Cloudflare for frontend website stuff
  frontend_proxied   = true
  frontend_subdomain = "${local.site_prefix}front"

  # Cloudflare for frontend website with www stuff
  www_frontend_proxied   = true
  www_frontend_subdomain = "www-${local.site_prefix}front"

  # Names of the S3 buckets that will hold the frontend stuff
  www_bucket_name = "${local.www_frontend_subdomain}.${local.site_domain}"
  bucket_name = "${local.frontend_subdomain}.${local.site_domain}"

  # Website Allowed origins
  allowed_origins = ["${local.api_subdomain}.${local.site_domain}"]

  # Name of ECS Cluster
  ecs_cluster_name = "${local.app_name}-${local.environment}-${local.aws_region}-cluster"

  # Name of the ALB to be created
  alb_name = "${local.app_name}-${local.environment}-${local.aws_region}-alb"

  #   Name of upload S3 bucket
  upload_bucket_prefix = "${local.app_name}-${local.environment}-${local.aws_region}-upload-bucket"

  parameter_group = "${local.app_name}/${local.environment}"

  # data for ECS Service
  ecs_service_cpu_multiplier                 = 1
  ecs_service_memory_multiplier              = 1
  ecs_service_ecs_service_name               = "${var.app_name}-${var.aws_region}-${var.environment}-service"
  ecs_service_bootstrap_task_definition_name = "${var.app_name}-${var.aws_region}-${var.environment}-bootstrap-td"
  ecs_service_task_definition_name           = "${var.app_name}-${var.aws_region}-${var.environment}-td"

  repository_prefix = "${local.aws_account_id}.dkr.ecr.${local.aws_region}.amazonaws.com"
  repository_url = {
    "backend" = "${local.repository_prefix}/vlcm-backend",
    "nginx"   = "${local.repository_prefix}/vlcm-nginx",
    "cron"    = "${local.repository_prefix}/vlcm-cron",
  }
}
