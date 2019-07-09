
# = = = = = = = = = = = = = = = = = = = = = = 
# Nat Gateway Module
# = = = = = = = = = = = = = = = = = = = = = = 

module "nat-gateway" {
  source          = "GoogleCloudPlatform/nat-gateway/google"
  version         = "1.2.0"
  name            = "prod-"
  project         = "${var.project}"
  region          = "${var.region}"
  zone            = "${var.zone}"
  ip_address_name = "${var.ip_address_name}"
}
