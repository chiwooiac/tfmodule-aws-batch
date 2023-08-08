variable "name" {
  description = "Specifies the name of the job definition."
  type        = string
}

variable "name_alias" {
  description = "Specifies the alias of the job definition."
  type        = string
}

variable "type" {
  description = "The type of job definition. Must be container"
  type        = string
  default     = "container"
}

variable "container_properties" {
  type        = any
  description = <<EOF
A valid container properties provided as a single valid JSON document.
This parameter is required if the type parameter is container.

container_properties = {
  executionRoleArn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  jobRoleArn       = "arn:aws:iam::123456789012:role/ecsJobExecutionRole"
  image            = "busybox"
  command          = ["echo", "hello"]
  timeout          = {
    attempt_duration_seconds = 3600
  }
  networkConfiguration = {
    assignPublicIp = "DISABLED"
  }
  fargatePlatformConfiguration = {
    platformVersion = "LATEST"
  }
  resourceRequirements = [
    {
      type  = "VCPU"
      value = "0.25"
    },
    {
      type  = "MEMORY"
      value = "512"
    }
  ]
  environment = [
    {
      "name" : "profile",
      "value" : "stg"
    },
    {
      "name" : "secret",
      "value" : "aGVsbG8sIHdvcmxkCg"
    }
  ]
}
EOF

}

variable "parameters" {
  description = "Specifies the parameter substitution placeholders to set in the job definition."
  type        = any
  default     = null
}

variable "platform_capabilities" {
  description = "The platform capabilities required by the job definition. If no value is specified, it defaults to EC2. To run the job on Fargate resources, specify FARGATE."
  type        = list(string)
  default     = ["FARGATE"]
}

variable "retry_strategy" {
  type        = any
  default     = {}
  description = <<EOF
Specifies the retry strategy to use for failed jobs that are submitted with this job definition.

retry_strategy = {
  attempts = 3
  evaluate_on_exit = [
    {
      action            = "EXIT"
      on_exit_code      = 0
      on_reason         = "exit"
      on_status_reason  = "Essential container in task exited"
    },
  {
      action            = "RETRY"
      on_exit_code      = 1
      on_status_reason  = "*"
      on_reason         = "error"
    }
  ]
}
EOF

}

variable "attempt_duration_seconds" {
  description = "The time duration in seconds after which AWS Batch terminates your jobs if they have not finished. The minimum value for the timeout is 60 seconds."
  type        = number
  default     = 60
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the job definition to the corresponding Amazon ECS task. Default is false."
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
