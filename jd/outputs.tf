output "job_definition" {
  description = "Map of job definition created and their associated attributes"
  value       = {
    name  = var.name_alias
    value = aws_batch_job_definition.this
  }
}

output "arn" {
  description = "ARN of the job definition"
  value       = {
    name  = var.name_alias
    value = aws_batch_job_definition.this.arn
  }
}
