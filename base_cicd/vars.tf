variable "CODESTAR_CONNECTOR_CREDENTIALS" {
  default = "arn:aws:codestar-connections:ap-southeast-1:249593777629:connection/f7623ad7-387d-4abc-ae08-7b83cd464851"
}

variable "TF_BUCKET" {
  default = "terraform-state20220108143755951900000001"
}

variable "CODEPIPELINE_BUCKET" {
  default = "codepipeline-artifacts20220108172710412300000001"
}

variable "TF_VERSION" {
  default = "4.33.0"
}

variable "TF_LOG" {
  default = "ERROR"
}