variable "name" {
  description = "The name of the Compute Environment."
  type        = string
}

variable "type" {
  description = "The type of the compute environment. Valid items are MANAGED or UNMANAGED."
  type        = string
  default     = "MANAGED"
}

variable "compute_type" {
  description = "The type of compute environment. Valid items are EC2, SPOT, FARGATE or FARGATE_SPOT."
  type        = string
  default     = "FARGATE_SPOT"
}


# EC2_Type
// The instance types that may be launched. You can specify instance families to launch any instance type within
// those families (for example, c5, c5n, or p3), or you can specify specific sizes within a family (such as c5.8xlarge).
// Note that metal instance types are not in the instance families (for example c5 does not include c5.metal.)
// You can also choose optimal to pick instance types (from the C, M, and R instance families) on the fly that match the
// demand of your job queues
variable "instance_type" {
  description = "The instance_type for compute environment to use."
  type        = list(string)
  default     = ["optimal"]
}

variable "max_vcpus" {
  description = "Maximum allowed VCPUs allocated to instances. maximum is 32"
  type        = number
  default     = 4
}

variable "min_vcpus" {
  description = "Minimum number of VCPUs allocated to instances."
  type        = number
  default     = 0
}

variable "desired_vcpus" {
  description = "Desired number of VCPUs allocated to instances."
  type        = number
  default     = 0
}

// Valid items are BEST_FIT_PROGRESSIVE, SPOT_CAPACITY_OPTIMIZED or BEST_FIT.
variable "allocation_strategy" {
  description = <<EOF
The allocation strategy to use for the compute resource in case not enough instances of the best fitting instance type can be allocated.
Valid items are BEST_FIT_PROGRESSIVE, SPOT_CAPACITY_OPTIMIZED or BEST_FIT. Defaults to BEST_FIT
EOF

  type    = string
  default = "BEST_FIT"
}

variable "enabled_default_security_group" {
  type    = bool
  default = true
}

variable "vpc_id" {
  description = "VPC ID to launch Compute Environment."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs to place Batch Worker nodes."
  type        = list(string)
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ids to be used by the Compute Environment."
}

# Batch Job Queue
variable "job_queues" {
  type    = any
  default = {
    jq1 = {
      name                  = "default"
      state                 = "ENABLED"
      priority              = 1
      scheduling_policy_arn = null
    }
  }

  description = <<EOF
job_queues = {
  one = {
    name = "one"
  }

  two = {
    name     = "two"
    state    = "ENABLED"
    priority = 2
  }

  three = {
    name     = "three"
    state    = "ENABLED"
    priority = 99
    fair_share_policy = {
      compute_reservation = 1
      share_decay_seconds = 3600
      share_distribution  = [
        {
          share_identifier = "A1*"
          weight_factor    = 0.1
        },
        {
          share_identifier = "A2"
          weight_factor    = 0.2
        }
      ]
    }
  }

}
EOF
}

# Batch Job Definition
variable "job_definitions" {
  type    = any
  default = {
    jd1 = {
      name                  = "default"
      type                  = "container"
      platform_capabilities = ["FARGATE"]
      container_properties  = {
        image   = "busybox"
        vcpus   = 1
        memory  = 128
        command = ["echo", "hello"]
      }
      parameters     = {}
      retry_strategy = {}
      timeout        = {
        attempt_duration_seconds = null
      }
    }
  }
  description = <<EOF

job_definitions = {
  busybox = {
    name                 = "busybox"
    container_properties = {
      executionRoleArn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
      jobRoleArn       = "arn:aws:iam::123456789012:role/ecsTaskJobRole"
      image            = "busybox"
      command          = ["echo", "two"]
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
      parameters     = {}
      retry_strategy = {}
      timeout        = {
        attempt_duration_seconds = null
      }
    }
  }
}
EOF

}
