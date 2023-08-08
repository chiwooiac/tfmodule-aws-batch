output "job_queues" {
  description = "Map of job queues created and their associated attributes"
  value       = aws_batch_job_queue.this
}
