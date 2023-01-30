# Local testing
## Set teraform remote state
`export TF_BUCKET=suni-terraform-state`
## Set ENV
`export BUILD_ENV=dev`
## Init terraform modules
./scripts/execute_terraform.sh $BUILD_ENV init
## Terraform plan
./scripts/execute_terraform.sh $BUILD_ENV plan