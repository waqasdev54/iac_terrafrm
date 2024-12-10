# Root directory structure:
# ├── main.tf
# ├── variables.tf
# ├── outputs.tf
# ├── modules/
#     ├── sns/
#     ├── eventbridge/
#     └── notifications/

# main.tf
provider "aws" {
  alias = "member"
  assume_role {
    role_arn = "arn:aws:iam::${var.member_account_id}:role/OrganizationAccountAccessRole"
  }
}

module "sns" {
  source         = "./modules/sns"
  providers = {
    aws = aws.member
  }
  member_accounts = var.member_accounts
}

module "eventbridge" {
  source         = "./modules/eventbridge"
  providers = {
    aws = aws.member
  }
  member_accounts = var.member_accounts
  sns_topics     = module.sns.topic_arns
}

module "notifications" {
  source         = "./modules/notifications"
  providers = {
    aws = aws.member
  }
  member_accounts     = var.member_accounts
  sns_topics         = module.sns.topic_arns
  alert_emails       = var.alert_emails
  default_alert_email = var.default_alert_email
}

# variables.tf
variable "member_accounts" {
  description = "Map of member account IDs and names"
  type        = map(string)
}

variable "alert_emails" {
  description = "Map of account IDs to alert email addresses"
  type        = map(string)
  default     = {}
}

variable "default_alert_email" {
  description = "Default email address for alerts if not specified in alert_emails"
  type        = string
}

variable "member_account_id" {
  description = "AWS Account ID of the member account"
  type        = string
}

# outputs.tf
output "sns_topic_arns" {
  description = "ARNs of created SNS topics"
  value       = module.sns.topic_arns
}

output "eventbridge_rule_arns" {
  description = "ARNs of created EventBridge rules"
  value       = module.eventbridge.rule_arns
}

# modules/sns/main.tf
resource "aws_sns_topic" "guardduty_alerts" {
  for_each = var.member_accounts
  name     = "guardduty-alerts-${each.key}"
}

resource "aws_sns_topic_policy" "guardduty_alerts_policy" {
  for_each = aws_sns_topic.guardduty_alerts

  arn    = each.value.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGuardDutyPublish"
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = each.value.arn
      }
    ]
  })
}

# modules/sns/variables.tf
variable "member_accounts" {
  description = "Map of member account IDs and names"
  type        = map(string)
}

# modules/sns/outputs.tf
output "topic_arns" {
  description = "Map of account IDs to SNS topic ARNs"
  value       = { for k, v in aws_sns_topic.guardduty_alerts : k => v.arn }
}

# modules/eventbridge/main.tf
resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  for_each    = var.member_accounts
  name        = "capture-guardduty-findings-${each.key}"
  description = "Capture GuardDuty findings for account ${each.key}"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "guardduty_findings_target" {
  for_each  = var.member_accounts
  rule      = aws_cloudwatch_event_rule.guardduty_findings[each.key].name
  target_id = "SendToSNS"
  arn       = var.sns_topics[each.key]

  input_transformer {
    input_paths = {
      severity    = "$.detail.severity"
      findingType = "$.detail.type"
      accountId   = "$.detail.accountId"
      region      = "$.region"
      title       = "$.detail.title"
      description = "$.detail.description"
    }
    input_template = <<EOF
{
  "Severity": <severity>,
  "Finding Type": "<findingType>",
  "Account ID": "<accountId>",
  "Region": "<region>",
  "Title": "<title>",
  "Description": "<description>"
}
EOF
  }
}

# modules/eventbridge/variables.tf
variable "member_accounts" {
  description = "Map of member account IDs and names"
  type        = map(string)
}

variable "sns_topics" {
  description = "Map of account IDs to SNS topic ARNs"
  type        = map(string)
}

# modules/eventbridge/outputs.tf
output "rule_arns" {
  description = "Map of account IDs to EventBridge rule ARNs"
  value       = { for k, v in aws_cloudwatch_event_rule.guardduty_findings : k => v.arn }
}

# modules/notifications/main.tf
resource "aws_sns_topic_subscription" "email" {
  for_each  = var.member_accounts
  topic_arn = var.sns_topics[each.key]
  protocol  = "email"
  endpoint  = lookup(var.alert_emails, each.key, var.default_alert_email)
}

# modules/notifications/variables.tf
variable "member_accounts" {
  description = "Map of member account IDs and names"
  type        = map(string)
}

variable "sns_topics" {
  description = "Map of account IDs to SNS topic ARNs"
  type        = map(string)
}

variable "alert_emails" {
  description = "Map of account IDs to alert email addresses"
  type        = map(string)
  default     = {}
}

variable "default_alert_email" {
  description = "Default email address for alerts if not specified in alert_emails"
  type        = string
}

# Example terraform.tfvars
# member_accounts = {
#   "111111111111" = "prod"
#   "222222222222" = "staging"
#   "333333333333" = "dev"
# }
# alert_emails = {
#   "111111111111" = "prod-alerts@example.com"
#   "222222222222" = "staging-alerts@example.com"
#   "333333333333" = "dev-alerts@example.com"
# }
# default_alert_email = "security@example.com"