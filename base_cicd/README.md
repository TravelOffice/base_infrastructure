# Init base cicde guide

`terraform init -backend-config="bucket=$ENV-itab-terraform-state" -backend-config="key=common/environments/$ENV/terraform.tfstate"`

`terraform apply`