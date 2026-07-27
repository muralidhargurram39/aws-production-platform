resource "aws_launch_template" "application" {
  name_prefix = "${local.name_prefix}-lt-"

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data     = base64encode(file("${path.module}/user_data.sh"))

  update_default_version = true

  iam_instance_profile {
    name = var.instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.application_security_group_id]
    delete_on_termination       = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-application"
        Backup = "true"
        
      }
    )
  }

  tag_specifications {
  resource_type = "volume"

  tags = merge(
    local.common_tags,
    {
      Backup = "true"
    }
  )
}

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-launch-template"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
