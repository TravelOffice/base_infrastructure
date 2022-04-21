output "BASE_INFRASTRUCTURE" {
  value = {
    backend = {
      vpc = {
        id              = module.base_backend_vpc.id
        private_subnets = module.base_backend_vpc.private_subnets
        public_subnets  = module.base_backend_vpc.public_subnets
      }
      secret_manager = {
        id = module.base_backend_secret_manager.id
      }
    }
  }
}

output "MARKETING" {
  value = {
    backend = {
      vpc = {
        id               = module.marketing_vpc.id
        public_subnets   = module.marketing_vpc.public_subnets
        private_subnets  = module.marketing_vpc.private_subnets
        database_subnets = module.marketing_vpc.database_subnets
      }
      secret_manager = {
        id = module.marketing_secret_manager.id
      }
      appsync = {
        id     = module.chat_appsync.id
        domain = module.chat_appsync.domain
      }
      dynamodb = {
        arn = module.sale_chat_dynamodb.arn
      }
    }
    frontend = {
      sale_web = {
        s3_bucket            = module.sale_frontend_hosting.s3_id
        attachment_s3_bucket = module.sale_chat_attachment_bucket.id
        cdn_domain           = module.sale_frontend_hosting.cdn_domain
      }
    }
  }
}

output "COMMON_CONFIG" {
  value = {
    region                         = "ap-southeast-1"
    codestar_connector_credentials = "arn:aws:codestar-connections:ap-southeast-1:249593777629:connection/f7623ad7-387d-4abc-ae08-7b83cd464851"
    tf_bucket                      = var.TF_BUCKET
    cognito = {
      user_pool = {
        id  = module.cognito_user_pool.id
        arn = module.cognito_user_pool.arn
      }
    }
    iam = {
      roles = {
        provision_tenant_infa_ecs_task_role = module.provisioning_tenant_infra_ecs_task_role.arn
      }
    }
    route53 = {
      hosted_zone = {
        id = "Z0837421MRKFPV1O1ZCI"
        domain = {
          name = "traveloffice.shop"
          certificate = {
            arn = "arn:aws:acm:ap-southeast-1:249593777629:certificate/2b282e8a-acad-4b69-aca0-9a6906e62c5f"
          }
        }
      }
    }
  }
}
