# tfmodule-aws-batch

`tfmodule-aws-batch` is a terraform module which creates AWS Batch resources.


## Usage

```hcl
module "batch" {
  source = "../../"

  context = {
    project     = "symple"
    name_prefix = "symple-an2s"
    tags        = { Team = "DevOps" }
  }

  name          = "lunar"
  vpc_id        = "vpc-0d259217b4297"
  subnet_ids    = ["subnet-0d259217b4297", "subnet-0d2eac17b4298"]
  min_vcpus     = 0
  max_vcpus     = 4
  desired_vcpus = 0
  job_queues    = {
    one = {
      name = "one"
    }
    two = {
      name     = "two"
      priority = 11
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
        command          = ["echo", "one"]
      }
      timeout = {
        attempt_duration_seconds = 3600
      }
    }

    two = {
      name                 = "two"
      container_properties = {
        executionRoleArn     = aws_iam_role.executor.arn
        # executionRoleArn = aws_iam_role.executor.arn
        image                = "busybox"
        command              = ["echo", "two"]
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
            "value" : "/stg/secret"
          }
        ]
      }
      timeout = {
        attempt_duration_seconds = 3600
      }
    }
  }

}
``` 
