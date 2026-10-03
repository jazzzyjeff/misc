locals {
  scps = {
    deny_all_outside_requested_regions = {
      name        = "deny-all-outside-requested-regions"
      description = "Deny all outside regions"

      statements = [
        {
          sid    = "DenyAllOutsideRequestedRegions"
          effect = "Deny"
          not_actions = [
            "aws-marketplace:*",
            "cloudfront:*",
            "iam:*",
            "organizations:*",
            "route53:*",
            "support:*"
          ]

          resources = ["*"]

          conditions = {
            StringNotEquals = {
              "aws:RequestedRegion" = [var.region]
            }
          }
        }
      ]
    }

    deny_org_escape = {
      name        = "deny-org-escape"
      description = "Deny leaving organisation"

      statements = [
        {
          sid    = "DenyLeavingOrg"
          effect = "Deny"
          actions = [
            "organizations:LeaveOrganization",
            "organizations:DeregisterDelegatedAdministrator"
          ]

          resources = ["*"]
        }
      ]
    }
  }

  default_tags = {
    Name = var.service
  }
}
