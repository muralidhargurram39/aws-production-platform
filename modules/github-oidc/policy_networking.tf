data "aws_iam_policy_document" "networking" {

  #
  # Read-only operations
  #

  #
  # Create APIs generally require Resource="*" because the target resource
  # does not exist before the API call.
  #
  #checkov:skip=CKV_AWS_109:Networking create APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_111:Networking create APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_356:Networking create APIs require Resource=*

  statement {
    sid    = "NetworkingRead"
    effect = "Allow"

    actions = [

      # EC2 / VPC
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeAddresses",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeNatGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",

      # Elastic Load Balancing
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",

      # Auto Scaling
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribePolicies"
    ]

    resources = ["*"]
  }

  #
  # Create operations
  # Create APIs generally require Resource="*" because the resource
  # does not exist yet.
  #
  statement {
    sid    = "NetworkingCreate"
    effect = "Allow"

    actions = [

      # VPC
      "ec2:CreateVpc",

      # Subnet
      "ec2:CreateSubnet",

      # Internet Gateway
      "ec2:CreateInternetGateway",

      # NAT Gateway
      "ec2:CreateNatGateway",

      # Elastic IP
      "ec2:AllocateAddress",

      # Route Tables
      "ec2:CreateRouteTable",
      "ec2:CreateRoute",

      # Launch Templates
      "ec2:CreateLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion",

      # Security Groups
      "ec2:CreateSecurityGroup",
      "ec2:CreateSecurityGroupRule",

      # Load Balancer
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup",

      # Auto Scaling
      "autoscaling:CreateAutoScalingGroup"
    ]

    resources = ["*"]
  }

  #
  # Update / Delete operations
  #
  statement {
    sid    = "NetworkingManage"
    effect = "Allow"

    actions = [

      # VPC
      "ec2:DeleteVpc",
      "ec2:ModifyVpcAttribute",

      # Subnet
      "ec2:DeleteSubnet",
      "ec2:ModifySubnetAttribute",

      # Internet Gateway
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:DeleteInternetGateway",

      # NAT Gateway
      "ec2:DeleteNatGateway",

      # Elastic IP
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",

      # Route Tables
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
      "ec2:ReplaceRoute",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",

      # Launch Templates
      "ec2:ModifyLaunchTemplate",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteLaunchTemplateVersions",

      # Security Groups
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:ModifySecurityGroupRules",
      "ec2:DeleteSecurityGroupRule",
      "ec2:DeleteSecurityGroup",

      # Load Balancer
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:DeleteLoadBalancer",

      # Listeners
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DeleteListener",

      # Target Groups
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:DeleteTargetGroup",

      # Auto Scaling
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:SuspendProcesses",
      "autoscaling:ResumeProcesses"
    ]

    resources = ["*"]
  }
}
