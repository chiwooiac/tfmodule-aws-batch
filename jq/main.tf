resource "aws_batch_job_queue" "this" {
  name                  = var.name
  state                 = var.state
  priority              = var.priority
  compute_environments  = var.compute_environments
  scheduling_policy_arn = var.scheduling_policy_arn
  tags                  = merge(var.tags, { JobQueue = var.name })
}


#resource "aws_batch_job_definition" "jd" {
#  name                 = var.batch_job_definition_name
#  type                 = "container"
#  container_properties = var.ecs_container_properties
#}
