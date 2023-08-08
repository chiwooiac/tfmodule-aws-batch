output "job_queue" {
  description = "Map of job queues created and their associated attributes"
  value       = {
    name  = var.name_alias
    value = aws_batch_job_queue.this
  }
}

output "arn" {
  description = "Map of job queues created and their associated attributes"
  value       = {
    name  = var.name_alias
    value = aws_batch_job_queue.this.arn
  }
}
