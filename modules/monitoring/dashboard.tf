resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title   = "EC2 CPU Utilization"
          region  = "ap-south-2"
          stat    = "Average"
          period  = 300
          view    = "timeSeries"

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              var.autoscaling_group_name
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title   = "Healthy Targets"
          region  = "ap-south-2"
          stat    = "Minimum"
          period  = 60
          view    = "timeSeries"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "TargetGroup",
              var.target_group_arn_suffix,
              "LoadBalancer",
              var.load_balancer_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title   = "ALB Request Count"
          region  = "ap-south-2"
          stat    = "Sum"
          period  = 300
          view    = "timeSeries"

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title   = "ALB 5XX Errors"
          region  = "ap-south-2"
          stat    = "Sum"
          period  = 300
          view    = "timeSeries"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_ELB_5XX_Count",
              "LoadBalancer",
              var.load_balancer_arn_suffix
            ]
          ]
        }
      }

    ]
  })

  lifecycle {
    create_before_destroy = true
  }
}
