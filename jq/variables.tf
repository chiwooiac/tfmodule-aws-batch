variable "name" {
  description = "Specifies the name of the job queue."
  type        = string
}

variable "state" {
  description = "state - (Required) The state of the job queue. Must be one of: ENABLED or DISABLED"
  type        = string
  default     = "ENABLED"
}

variable "compute_environments" {
  description = "Specifies the set of compute environments mapped to a job queue and their order. The position of the compute environments in the list will dictate the order."
  type        = list(string)
}

variable "priority" {
  description = "The priority of the job queue. Job queues with a higher priority are evaluated first when associated with the same compute environment."
  type        = number
  default     = 1
}

variable "scheduling_policy_arn" {
  description = <<EOF
  The ARN of the fair share scheduling policy. If this parameter is specified, the job queue uses a fair share scheduling policy. If this parameter isn't specified, the job queue uses a first in, first out (FIFO) scheduling policy. After a job queue is created, you can replace but can't remove the fair share scheduling policy.
EOF

  type        = string
  default     = null
}

variable "tags" {
  description = "Subnet Prefix name to place Batch Worker nodes."
  type        = map(string)
  default     = {}
}
