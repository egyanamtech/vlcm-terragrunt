locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
include {
  path = find_in_parent_folders()
}
terraform {
  # source = "../ecs-service"
  source = "git::ssh://git@github.com/egyanamtech/vlcm-terraform.git//ecs-service?ref=v0.0.14"
}

inputs = {
  name                           = "ecs-service"
  cpu_multiplier                 = local.env.locals.ecs_service_cpu_multiplier
  memory_multiplier              = local.env.locals.ecs_service_memory_multiplier
  ecs_service_name               = local.env.locals.ecs_service_ecs_service_name
  task_definition_name           = local.env.locals.ecs_service_task_definition_name
  environment = [
    { "name" : "DJANGO_ALLOWED_HOSTS", "value" : "${local.env.locals.api_subdomain}.${local.env.locals.site_domain}, ${dependency.alb.outputs.alb_dns_name}" },
    { "name" : "DJANGO_SECRET_KEY", "value" : "'insecure'" },
    { "name" : "USE_S3", "value" : "True" },
    { "name" : "ON_ECS", "value" : "True" },
    { "name" : "DEBUG", "value" : "False" }
  ]
  secrets = [
    {
      "valueFrom" : dependency.postgres.outputs.db_endpoint,
      "name" : "DATABASE_HOST"
    },
    {
      "valueFrom" : dependency.postgres.outputs.db_port,
      "name" : "DATABASE_PORT"
    },
    {
      "valueFrom" : dependency.postgres.outputs.db_master_pass,
      "name" : "DATABASE_PASSWORD"
    },
    {
      "valueFrom" : dependency.postgres.outputs.db_username,
      "name" : "DATABASE_USERNAME"
    },
    {
      "valueFrom" : dependency.postgres.outputs.db_name,
      "name" : "DATABASE_NAME"
    },
    {
      "valueFrom" : dependency.redis.outputs.redis_host,
      "name" : "REDIS_HOST"
    },
    {
      "valueFrom" : dependency.redis.outputs.redis_port,
      "name" : "REDIS_PORT"
    },
    {
      "valueFrom" : dependency.s3-upload.outputs.s3_bucket_name_ssm,
      "name" : "AWS_BUCKET"
    }
  ]
  postgres_sg = dependency.postgres.outputs.postgres_sg
  redis_sg    = dependency.redis.outputs.redis_sg
  alb_sg      = dependency.alb.outputs.alb_sg
  alb_arn     = dependency.alb.outputs.alb_arn

  vpc_id          = dependency.network.outputs.vpc_id
  private_subnets = dependency.network.outputs.private_subnets

  ecs_cluster_id = dependency.ecs-cluster.outputs.cluster_id

  s3_bucket_policy_arn = dependency.s3-upload.outputs.s3_policy_arn
}

dependency "ecs-cluster" {
  config_path                             = "../ecs-cluster"
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
  mock_outputs = {
    cluster_id = "mock_cluster_id"
  }
}

dependency "postgres" {
  config_path = "../postgres"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    postgres_sg    = "mock_postgres_sg_id"
    db_endpoint    = "mock_db_endpoint"
    db_port        = "mock_db_port"
    db_master_pass = "mock_db_master_pass"
    db_username    = "mock_db_username"
    db_name        = "mock_db_name"
  }
}

dependency "redis" {
  config_path = "../redis"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    redis_sg   = "mock_redis_sg_id"
    redis_host = "mock_redis_host"
    redis_port = "mock_redis_port"
  }
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    alb_arn = "arn:aws:ecs:ap-south-1:123456789012:alb:mock_alb_arn"
    # alb_arn = "arn:aws:alb:mock_alb_arn:::"
    alb_sg = "mock_alb_sg"
    alb_dns_name = "mock.alb.name"
  }
}

dependency "network" {
  config_path = "../network"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    vpc_id          = "mock_vpc_id"
    private_subnets = ["mock_private_subnets"]
  }
}

dependency "s3-upload" {
  config_path = "../s3-upload-bucket"

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]

  mock_outputs = {
    s3_policy_arn      = "mock_s3_policy_arn"
    s3_bucket_name_ssm = "mock_s3_bucket_name_ssm"
  }
}
