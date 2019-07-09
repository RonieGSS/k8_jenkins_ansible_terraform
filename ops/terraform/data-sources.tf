
# = = = = = = = = = = = = = = = = = = = = = = 
# Network Auth Data Source
# = = = = = = = = = = = = = = = = = = = = = = 

data "null_data_source" "auth_mysql_allowed_1" {
  count = 1
  inputs = {
    value = "${element(list(var.sql_dev_server_ip), count.index)}"
  }
}

# = = = = = = = = = = = = = = = = = = = = = = 
# GCS Terraform State Path
# = = = = = = = = = = = = = = = = = = = = = = 

data "terraform_remote_state" "terraform-state-gcs" {
  backend   = "gcs"
  config {
    bucket  = "tfstate-bucket"
    project = "${var.project}"
    path    = "terraform/state/terraform.tfstate"
  }
}
