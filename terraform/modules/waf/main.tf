resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.metric_name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 0
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 4
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesUnixRuleSet"
    priority = 5
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "AWS-AWSManagedRulesUnixRuleSet"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesWindowsRuleSet"
    priority = 6
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWindowsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "AWS-AWSManagedRulesWindowsRuleSet"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = var.waf_association_resource_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
  resource_arn            = aws_wafv2_web_acl.this.arn

  redacted_fields {
    single_header {
      name = "user-agent"
    }
  }
  redacted_fields {
    uri_path {}
  }
}

resource "aws_cloudwatch_log_group" "waf" {
  name = "aws-waf-logs-group"
}

resource "aws_iam_role" "waf" {
  name = "waf-logging"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "waf.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch-group-access" {
  name = "cloudwatch-group-access"
  role = aws_iam_role.waf.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
          aws_cloudwatch_log_group.waf.arn,
          "${aws_cloudwatch_log_group.waf.arn}:*"
        ]
      }
    ]
  })
}