output "default_security_group_id" {
  value = var.enabled_default_security_group ? aws_security_group.this[0].id : null
}

output "job_queues" {
  description = "Map of job queues created and their associated attributes"
  value       = toset([
    for j in module.jq : j
  ])
}

