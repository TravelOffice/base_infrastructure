# Local testing
## Set teraform remote state
`export TF_BUCKET=terraform-state20220108143755951900000001`
## Set ENV
`export BUILD_ENV=dev`
## Init terraform modules
./scripts/execute_terraform.sh $BUILD_ENV init
## Terraform plan
./scripts/execute_terraform.sh $BUILD_ENV plan