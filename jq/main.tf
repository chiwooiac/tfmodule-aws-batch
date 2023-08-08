locals {
  jq_name = format("%s-jq", var.name)
}

resource "aws_batch_job_queue" "this" {
  name                  = local.jq_name
  state                 = var.state
  priority              = var.priority
  compute_environments  = var.compute_environments
  scheduling_policy_arn = var.scheduling_policy_arn
  tags                  = merge(var.tags, { JobQueue = local.jq_name })
}
