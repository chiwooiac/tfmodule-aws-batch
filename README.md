# tfmodule-aws-batch
tfmodule-aws-batch

## Usage


```hcl
module "batch" {
  source = "../../"

  context            = {
    project     = "symple"
    name_prefix = "symple-mc1s"
    tags        = {
      Team = "DevOps",
    }
  }
  name               = "alice"
  vpc_id             = "vpc_1234567"
  subnet_prefix_name = "subnet_1234567"
  min_vcpus          = 0
  max_vcpus          = 2
  desired_vcpus      = 0
  job_queues         = {
    default = {
      name = "default"
    }
  }
  job_definitions = {
    one = {
      name                 = "one"
      container_properties = {
        executionRoleArn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
        jobRoleArn       = "arn:aws:iam::123456789012:role/ecsJobExecutionRole"
        image            = "busybox"
        vcpus            = 1
        memory           = 128
        command          = ["echo", "two"]
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
    }
  }

}
``` 
