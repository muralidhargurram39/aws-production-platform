locals {

  parameter_name = "/platform/${var.project_name}/${var.environment}/cloudwatch-agent"

}

locals {

  cloudwatch_agent_config = jsonencode({

    metrics = {

      append_dimensions = {
        AutoScalingGroupName = "$${aws:AutoScalingGroupName}"
        InstanceId           = "$${aws:InstanceId}"
      }

      metrics_collected = {

        mem = {
          measurement = [
            "mem_used_percent"
          ]
        }

        disk = {
          measurement = [
            "used_percent"
          ]
          resources = [
            "/"
          ]
        }
      }
    }

    logs = {

      logs_collected = {

        files = {

          collect_list = [

            {
              file_path       = "/var/log/messages"
              log_group_name  = "/aws/ec2/messages"
              log_stream_name = "{instance_id}"
            },

            {
              file_path       = "/var/log/secure"
              log_group_name  = "/aws/ec2/secure"
              log_stream_name = "{instance_id}"
            },

            {
              file_path       = "/var/log/cloud-init.log"
              log_group_name  = "/aws/ec2/cloud-init"
              log_stream_name = "{instance_id}"
            },

            {
              file_path       = "/var/log/cloud-init-output.log"
              log_group_name  = "/aws/ec2/cloud-init"
              log_stream_name = "{instance_id}"
            },

            {
              file_path       = "/var/log/nginx/access.log"
              log_group_name  = "/aws/ec2/nginx"
              log_stream_name = "{instance_id}"
            },

            {
              file_path       = "/var/log/nginx/error.log"
              log_group_name  = "/aws/ec2/nginx"
              log_stream_name = "{instance_id}"
            }

          ]
        }
      }
    }

  })

}
