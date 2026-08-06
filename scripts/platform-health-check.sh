#!/bin/bash

set -e

START_TIME=$(date +%s)
START_DATE=$(date)

# Verify AWS CLI is installed
if ! command -v aws >/dev/null 2>&1; then
    echo "ERROR: AWS CLI is not installed."
    exit 1
fi

# Verify AWS credentials
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    echo "ERROR: AWS credentials are not configured."
    exit 1
fi

REGION="ap-south-2"

PROJECT="aws-production-platform"

ENVIRONMENT="dev"

ACCOUNT_ID=$(aws sts get-caller-identity \
--query Account \
--output text)

PASS=0
FAIL=0

pass() {
    printf "%-45s \033[32m✔ PASS\033[0m\n" "$1"
    PASS=$((PASS + 1))
}

fail() {
    printf "%-45s \033[31m✖ FAIL\033[0m\n" "$1"
    FAIL=$((FAIL + 1))
}

echo

echo "===================================================="
echo " AWS Production Platform Health Check"
echo "===================================================="
echo
printf "%-15s : %s\n" "Project" "$PROJECT"
printf "%-15s : %s\n" "Environment" "$ENVIRONMENT"
printf "%-15s : %s\n" "Region" "$REGION"
printf "%-15s : %s\n" "AWS Account" "$ACCOUNT_ID"
printf "%-15s : %s\n" "Started" "$START_DATE"
echo
echo "----------------------------------------------------"
echo

echo "---------------- NETWORK ----------------"

VPC=$(aws ec2 describe-vpcs \
    --region $REGION \
    --filters Name=tag:Project,Values=$PROJECT \
    Name=tag:Environment,Values=$ENVIRONMENT \
    --query "Vpcs[0].VpcId" \
    --output text)

if [[ "$VPC" != "None" ]]; then

    pass "VPC"

else

    fail "VPC"

fi

PUBLIC_SUBNETS=$(aws ec2 describe-subnets \
    --region $REGION \
    --filters \
        Name=vpc-id,Values=$VPC \
        Name=tag:Type,Values=Public \
    --query "length(Subnets)" \
    --output text)

if [[ "$PUBLIC_SUBNETS" -eq 3 ]]; then
    pass "Public Subnets ($PUBLIC_SUBNETS)"
else
    fail "Public Subnets"
fi

PRIVATE_SUBNETS=$(aws ec2 describe-subnets \
    --region $REGION \
    --filters \
        Name=vpc-id,Values=$VPC \
        Name=tag:Type,Values=Private \
    --query "length(Subnets)" \
    --output text)

if [[ "$PRIVATE_SUBNETS" -eq 3 ]]; then
    pass "Private Subnets ($PRIVATE_SUBNETS)"
else
    fail "Private Subnets"
fi

DATABASE_SUBNETS=$(aws ec2 describe-subnets \
    --region $REGION \
    --filters \
        Name=vpc-id,Values=$VPC \
        Name=tag:Type,Values=Database \
    --query "length(Subnets)" \
    --output text)

if [[ "$DATABASE_SUBNETS" -eq 3 ]]; then
    pass "Database Subnets ($DATABASE_SUBNETS)"
else
    fail "Database Subnets"
fi

echo
echo "---------------- COMPUTE ----------------"

ASG_NAME="${PROJECT}-${ENVIRONMENT}-asg"

ASG=$(aws autoscaling describe-auto-scaling-groups \
    --region $REGION \
    --auto-scaling-group-names "$ASG_NAME" \
    --query "AutoScalingGroups[0].AutoScalingGroupName" \
    --output text)

if [[ "$ASG" == "$ASG_NAME" ]]; then
    pass "Auto Scaling Group"
else
    fail "Auto Scaling Group"
fi

INSTANCE_COUNT=$(aws ec2 describe-instances \
    --region $REGION \
    --filters \
        Name=tag:Project,Values=$PROJECT \
        Name=tag:Environment,Values=$ENVIRONMENT \
        Name=instance-state-name,Values=running \
    --query "length(Reservations[].Instances[])" \
    --output text)

if [[ "$INSTANCE_COUNT" -ge 2 ]]; then
    pass "Running EC2 Instances ($INSTANCE_COUNT)"
else
    fail "Running EC2 Instances"
fi

echo
echo "------------- LOAD BALANCING ------------"

ALB_NAME="${PROJECT}-${ENVIRONMENT}-alb"

ALB=$(aws elbv2 describe-load-balancers \
    --region $REGION \
    --names "$ALB_NAME" \
    --query "LoadBalancers[0].State.Code" \
    --output text 2>/dev/null || echo "missing")

if [[ "$ALB" == "active" ]]; then
    pass "Application Load Balancer"
else
    fail "Application Load Balancer"
fi

TG_NAME="${PROJECT}-${ENVIRONMENT}-tg"

HEALTHY_TARGETS=$(aws elbv2 describe-target-health \
    --region $REGION \
    --target-group-arn $(aws elbv2 describe-target-groups \
        --region $REGION \
        --names "$TG_NAME" \
        --query "TargetGroups[0].TargetGroupArn" \
        --output text) \
    --query "length(TargetHealthDescriptions[?TargetHealth.State=='healthy'])" \
    --output text)

if [[ "$HEALTHY_TARGETS" -ge 2 ]]; then
    pass "Healthy Targets ($HEALTHY_TARGETS)"
else
    fail "Healthy Targets"
fi

echo
echo "--------------- EDGE --------------------"

CF_ID=$(aws cloudfront list-distributions \
    --query "DistributionList.Items[?contains(Comment, '${PROJECT}-${ENVIRONMENT}')].Id | [0]" \
    --output text)

if [[ "$CF_ID" != "None" && "$CF_ID" != "null" ]]; then

    CF_STATUS=$(aws cloudfront get-distribution \
        --id "$CF_ID" \
        --query "Distribution.Status" \
        --output text)

    if [[ "$CF_STATUS" == "Deployed" ]]; then
        pass "CloudFront Distribution"
    else
        fail "CloudFront Distribution"
    fi

else

    fail "CloudFront Distribution"

fi

echo
echo "--------------- DNS ---------------------"

HOSTED_ZONE=$(aws route53 list-hosted-zones \
    --query "HostedZones[?Name=='muralidharops.com.'].Id | [0]" \
    --output text)

if [[ "$HOSTED_ZONE" != "None" ]]; then
    pass "Route53 Hosted Zone"
else
    fail "Route53 Hosted Zone"
fi

ROOT_RECORD=$(aws route53 list-resource-record-sets \
    --hosted-zone-id "${HOSTED_ZONE##*/}" \
    --query "length(ResourceRecordSets[?Type=='A' && Name=='muralidharops.com.'])" \
    --output text)

if [[ "$ROOT_RECORD" -eq 1 ]]; then
    pass "Root DNS Record"
else
    fail "Root DNS Record"
fi

WWW_RECORD=$(aws route53 list-resource-record-sets \
    --hosted-zone-id "${HOSTED_ZONE##*/}" \
    --query "length(ResourceRecordSets[?Type=='A' && Name=='www.muralidharops.com.'])" \
    --output text)

if [[ "$WWW_RECORD" -eq 1 ]]; then
    pass "WWW Alias Record"
else
    fail "WWW Alias Record"
fi

echo
echo "------------- CERTIFICATES --------------"

GLOBAL_CERT=$(aws acm list-certificates \
    --region us-east-1 \
    --query "CertificateSummaryList[?DomainName=='muralidharops.com'].Status | [0]" \
    --output text)

if [[ "$GLOBAL_CERT" == "ISSUED" ]]; then
    pass "ACM (CloudFront)"
else
    fail "ACM (CloudFront)"
fi

REGIONAL_CERT=$(aws acm list-certificates \
    --region $REGION \
    --query "CertificateSummaryList[?DomainName=='origin.muralidharops.com'].Status | [0]" \
    --output text)

if [[ "$REGIONAL_CERT" == "ISSUED" ]]; then
    pass "ACM (Regional)"
else
    fail "ACM (Regional)"
fi

echo
echo "-------------- SECURITY -----------------"

WAF=$(aws wafv2 list-web-acls \
    --scope CLOUDFRONT \
    --region us-east-1 \
    --query "WebACLs[0].Name" \
    --output text)

if [[ "$WAF" != "None" ]]; then
    pass "AWS WAF"
else
    fail "AWS WAF"
fi

echo
echo "------------ OBSERVABILITY --------------"

CLOUDTRAIL_STATUS=$(aws cloudtrail get-trail-status \
    --name "${PROJECT}-${ENVIRONMENT}-cloudtrail" \
    --query "IsLogging" \
    --output text 2>/dev/null || echo "False")

if [[ "$CLOUDTRAIL_STATUS" == "True" ]]; then
    pass "CloudTrail Logging"
else
    fail "CloudTrail Logging"
fi

FLOW_LOGS=$(aws ec2 describe-flow-logs \
    --region "$REGION" \
    --query "length(FlowLogs[?ResourceId=='$VPC' && FlowLogStatus=='ACTIVE'])" \
    --output text)

if [[ "$FLOW_LOGS" -ge 1 ]]; then
    pass "VPC Flow Logs"
else
    fail "VPC Flow Logs"
fi

DASHBOARD=$(aws cloudwatch list-dashboards \
    --query "DashboardEntries[?DashboardName=='${PROJECT}-${ENVIRONMENT}-dashboard'] | length(@)" \
    --output text)

if [[ "$DASHBOARD" -eq 1 ]]; then
    pass "CloudWatch Dashboard"
else
    fail "CloudWatch Dashboard"
fi

echo
echo "--------------- BACKUP ------------------"

BACKUP_VAULT=$(aws backup list-backup-vaults \
    --query "BackupVaultList[?BackupVaultName=='${PROJECT}-${ENVIRONMENT}-backup-vault'] | length(@)" \
    --output text)

if [[ "$BACKUP_VAULT" -eq 1 ]]; then
    pass "AWS Backup Vault"
else
    fail "AWS Backup Vault"
fi

echo
echo "===================================================="
echo "                    SUMMARY"
echo "===================================================="

echo

printf "%-18s : %d\n" "Checks Passed" "$PASS"
printf "%-18s : %d\n" "Checks Failed" "$FAIL"

echo	

if [[ "$FAIL" -eq 0 ]]; then

    echo -e "\033[32mPlatform Status : HEALTHY\033[0m"

else

    echo -e "\033[31mPlatform Status : UNHEALTHY\033[0m"

fi

END_TIME=$(date +%s)
END_DATE=$(date)
ELAPSED=$((END_TIME - START_TIME))

echo

printf "%-18s : %s\n" "Completed" "$END_DATE"
printf "%-18s : %s seconds\n" "Execution Time" "$ELAPSED"

echo
