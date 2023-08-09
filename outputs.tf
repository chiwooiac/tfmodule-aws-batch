output "ecs_cluster_arn" {
  value = aws_batch_compute_environment.this.ecs_cluster_arn
}

output "default_security_group_id" {
  value = var.enabled_default_security_group ? aws_security_group.this[0].id : null
}

output "job_queues" {
  description = "Map of job queues created and their associated attributes"
  value       = {
    for k in module.jq :
    k.job_queue.name => k.job_queue.value
  }
}

output "job_queue_arns" {
  description = "Map of job queues arn"
  value       = {
    for k in module.jq :
    k.arn.name => k.arn.value
  }
}

output "job_definitions" {
  description = "Map of job_definitions created and their associated attributes"
  value       = {
    for k in module.jd :
    k.job_definition.name => k.job_definition.value
  }
}

output "job_definition_arns" {
  description = "Map of job_definitions arn"
  value       = {
    for k in module.jd :
    k.arn.name => k.arn.value
  }
}

output "batch_service_policy_name" {
  value = local.batch_service_policy_name
}

output "batch_instance_policy_name" {
  value = local.batch_instance_policy_name
}
