output "BASE_INFRASTRUCTURE" {
  value = {
    backend = {
      /* vpc = {
        id              = module.base_backend_vpc.id
        private_subnets = module.base_backend_vpc.private_subnets
        public_subnets  = module.base_backend_vpc.public_subnets
        security_groups = {
          lambda_sg = aws_security_group.base_backend_lambda_sg.id
        }
      } */
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
        security_groups = {
          lambda_sg = aws_security_group.marketing_lambda_sg.id
        }
      }
      secret_manager = {
        id = module.marketing_secret_manager.id
      }
      appsync = {
        id     = module.chat_appsync.id
        arn    = module.chat_appsync.arn
        name   = module.chat_appsync.name
        domain = module.chat_appsync.domain
      }
      dynamodb = {
        travel_table = {
          arn        = module.travel_table_dynamodb.arn
          stream_arn = module.travel_table_dynamodb.stream_arn
          name       = module.travel_table_dynamodb.db_name
        }
        chat_table = {
          arn        = module.chat_table_dynamodb.arn
          stream_arn = module.chat_table_dynamodb.stream_arn
          name       = module.chat_table_dynamodb.db_name
        }
        marketplace_table = {
          arn        = module.marketplace_table_dynamodb.arn
          stream_arn = module.marketplace_table_dynamodb.stream_arn
          name       = module.marketplace_table_dynamodb.db_name
        }
        statistic_table = {
          arn  = module.statistic_table_dynamodb.arn
          name = module.statistic_table_dynamodb.db_name
        }
        role_permission_table = {
          arn  = module.role_permission_table_dynamodb.arn
          name = module.role_permission_table_dynamodb.db_name
        }
        notification_table = {
          arn  = module.notification_table_dynamodb.arn
          name = module.notification_table_dynamodb.db_name
        }
      }
    }
    frontend = {
      sale_web = {
        s3_bucket            = module.sale_frontend_hosting.s3_id
        attachment_s3_bucket = module.sale_chat_attachment_bucket.id
        cdn_domain           = module.sale_frontend_hosting.cdn_domain
      }
      marketplace_web = {
        attachment_s3_bucket = module.marketplace_attachment_bucket.id
      }

    }
    queue = {
      auto_assign_chat_queue    = module.queue.new_conversation_queue_arn
      system_notification_queue = module.system_notification_sqs.arn
      system_subscribe_queue    = module.system_subscribe_sqs.arn
      system_unsubscribe_queue  = module.system_unsubscribe_sqs.arn
    }
    search = {
      lb_arn                 = module.loadbalancer.lb_arn
      lb_endpoint            = module.loadbalancer.lb_endpoint
      lb_front_end_http_arn  = module.loadbalancer.lb_front_end_http_arn
      lb_front_end_https_arn = module.loadbalancer.lb_front_end_https_arn
    }
    s3 = {
      script_bucket = module.script_bucket.id
    }
  }
}

output "COMMON_CONFIG" {
  value = {
    region                         = var.AWS_REGION
    codestar_connector_credentials = nonsensitive(local.codestar_connector_credentials)
    tf_bucket                      = nonsensitive(local.tf_state_bucket)
    codepipeline_bucket            = nonsensitive(local.codepipeline_bucket)
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
        id = nonsensitive(local.hosted_zone_id)
        domain = {
          name = nonsensitive(local.hosted_domain_name)
          certificate = {
            api_gateway = nonsensitive(local.api_gateway_acm)
            cloudfront  = nonsensitive(local.cloudfront_acm)
          }
        }
      }
    }
  }
}
