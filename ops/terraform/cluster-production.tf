
# = = = = = = = = = = = = = = = = = = = = = = 
# DNS
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_dns_record_set" "production-template-net" {
  name = "${var.template_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_zone}"
  rrdatas = ["${var.ip_for_template_wordpress}"]
}

resource "google_dns_record_set" "tmp-prod-template-net" {
  name = "prod.${var.template_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_zone}"
  rrdatas = ["22.22.22.22"]
}

resource "google_dns_record_set" "tmp-prod-admin-template-net" {
  name = "prod-admin.${var.template_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_zone}"
  rrdatas = ["22.22.22.11"]
}

resource "google_dns_record_set" "production-template-net-main" {
  name = "my.${var.template_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_zone}"
  rrdatas = ["${var.ip_for_template_production}"]
}

resource "google_dns_record_set" "production-admin-template-net" {
  name = "admin.${var.template_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_zone}"
  rrdatas = ["${var.ip_for_template_admin_production}"]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# Firewall
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_firewall" "cluster-production" {
  name    = "cluster-production"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["${google_container_cluster.cluster-production.node_config.0.tags}"]
}

# = = = = = = = = = = = = = = = = = = = = = =
# Kubernetes Cluster
# = = = = = = = = = = = = = = = = = = = = = =

resource "google_container_cluster" "cluster-production" {
  project            = "${var.project}"
  name               = "${var.cluster_prod_name}"
  zone               = "${var.zone}"
  enable_legacy_abac = true
  initial_node_count = 1

  master_auth {
    username = "${var.cluster_prod_username}"
    password = "${var.cluster_prod_password}"
  }

  node_config {
    machine_type = "n1-standard-2"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    tags = ["cluster-production"]
  }
}

# = = = = = = = = = = = = = = = = = = = = = = 
# disk
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_disk" "cluster-production" {
  name  = "cluster-production-disk"
  type  = "pd-standard"
  zone  = "${var.zone}"
  size  = "20"
  image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20180613"
  labels {
    environment = "cluster-production"
  }
}
