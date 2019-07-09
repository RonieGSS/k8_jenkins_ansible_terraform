
# = = = = = = = = = = = = = = = = = = = = = = 
# GCS Backend for tfstate
# = = = = = = = = = = = = = = = = = = = = = = 

terraform {
  backend "gcs" {
    bucket  = "tfstate-bucket"
    prefix  = "terraform/state"
  }
}