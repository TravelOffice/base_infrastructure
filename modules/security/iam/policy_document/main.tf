module "secret_manager_read" {
    source = "./secret_manager_read"
}

output "secret_manager_read_policy" {
    value = module.secret_manager_read.policy_json
}