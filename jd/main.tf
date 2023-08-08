locals {
  jd_name = format("%s-jd", var.name)
}

resource "aws_batch_job_definition" "this" {
  name                  = local.jd_name
  type                  = var.type
  platform_capabilities = var.platform_capabilities
  container_properties  = var.container_properties
  parameters            = var.parameters

  dynamic "retry_strategy" {
    for_each = length(var.retry_strategy) > 0 ? [var.retry_strategy] : []
    content {
      attempts = lookup(retry_strategy.value, "attempts", null)
      dynamic "evaluate_on_exit" {
        for_each = lookup(retry_strategy.value, "evaluate_on_exit", [])
        content {
          action           = evaluate_on_exit.value.action
          on_exit_code     = try(evaluate_on_exit.value.on_exit_code, null)
          on_reason        = try(evaluate_on_exit.value.on_reason, null)
          on_status_reason = try(evaluate_on_exit.value.on_status_reason, null)
        }
      }
    }
  }

  dynamic "timeout" {
    for_each = var.attempt_duration_seconds != null ? [1] : []
    content {
      attempt_duration_seconds = var.attempt_duration_seconds
    }
  }

  propagate_tags = var.propagate_tags

  tags = merge(var.tags, { Name = local.jd_name })

}
