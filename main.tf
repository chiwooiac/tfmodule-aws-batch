locals {
  project                  = var.context.project
  name_prefix              = var.context.name_prefix
  tags                     = var.context.tags
  compute_environment_name = format("%s-%s-ce", local.name_prefix, var.name)
  ecs_cluster_name         = format("%s-%s-ecs", local.name_prefix, var.name)
  sg_name                  = format("%s-%s-sg", local.name_prefix, var.name)
  job_prefix_name          = format("%s-%s", local.name_prefix, var.name)
  security_group_ids       = var.enabled_default_security_group ? concat(var.security_group_ids, [
    aws_security_group.this[0].id
  ]) : var.security_group_ids
}

resource "aws_batch_compute_environment" "this" {
  compute_environment_name = local.compute_environment_name
  service_role             = aws_iam_role.svcRole.arn
  type                     = var.type

  # EC2_TYPE
  dynamic "compute_resources" {
    for_each = var.compute_type == "EC2" || var.compute_type == "SPOT" ? [1] : []
    content {
      type                = var.compute_type
      instance_role       = aws_iam_instance_profile.ecs.arn
      instance_type       = tolist(var.instance_type)
      security_group_ids  = local.security_group_ids
      subnets             = coalesce(var.subnet_ids)
      min_vcpus           = var.min_vcpus
      max_vcpus           = var.max_vcpus
      desired_vcpus       = var.desired_vcpus
      allocation_strategy = var.allocation_strategy
    }
  }

  # FARGATE_TYPE
  dynamic "compute_resources" {
    for_each = var.compute_type == "FARGATE" || var.compute_type == "FARGATE_SPOT" ? [1] : []
    content {
      type               = var.compute_type
      security_group_ids = local.security_group_ids
      subnets            = coalesce(var.subnet_ids)
      min_vcpus          = var.min_vcpus
      max_vcpus          = var.max_vcpus
      desired_vcpus      = var.desired_vcpus
    }
  }

  tags = merge(local.tags, { Name = local.compute_environment_name })

  // To prevent a race condition during environment deletion, make sure to set depends_on to the related
  // aws_iam_role_policy_attachment; otherwise, the policy may be destroyed too soon and the compute environment
  // will then get stuck in the DELETING.
  // ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_compute_environment
  depends_on = [aws_iam_role_policy_attachment.svcRole]
}

module "jq" {
  source                = "./jq/"
  for_each              = {for k, v in var.job_queues : k => v if length(var.job_queues) > 0}
  name                  = format("%s-%s", local.job_prefix_name, each.value.name)
  name_alias            = each.value.name
  state                 = try(each.value.state, "ENABLED")
  priority              = try(each.value.priority, 1)
  scheduling_policy_arn = try(each.value.scheduling_policy_arn, null)
  compute_environments  = [aws_batch_compute_environment.this.arn]
  tags                  = local.tags
  depends_on            = [aws_batch_compute_environment.this]
}

module "jd" {
  source                   = "./jd/"
  for_each                 = {for k, v in var.job_definitions : k => v if length(var.job_definitions) > 0}
  name                     = format("%s-%s", local.job_prefix_name, each.value.name)
  name_alias               = each.value.name
  type                     = try(each.value.type, "container")
  platform_capabilities    = try(each.value.platform_capabilities, ["FARGATE"])
  container_properties     = try(jsonencode(each.value.container_properties), {})
  retry_strategy           = try(each.value.retry_strategy, {})
  parameters               = try(each.value.parameters, null)
  attempt_duration_seconds = lookup(try(each.value.timeout, {}), "attempt_duration_seconds", null)
  tags                     = local.tags
  depends_on               = [aws_batch_compute_environment.this]
}
