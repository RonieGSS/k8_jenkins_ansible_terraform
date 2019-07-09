
# = = = = = = = = = = = = = = = = = = = = = = 
# DNS
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_dns_record_set" "staging-template-net" {
  name = "stg.${var.template_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_zone}"
  rrdatas = ["${var.ip_for_template_staging}"]
}

resource "google_dns_record_set" "staging-admin-template-net" {
  name = "stg-admin.${var.template_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_zone}"
  rrdatas = ["${var.ip_for_template_admin_staging}"]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# Firewall
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_firewall" "cluster-staging" {
  name    = "cluster-staging"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["${google_container_cluster.cluster-staging.node_config.0.tags}"]
}

# = = = = = = = = = = = = = = = = = = = = = =
# Kubernetes Cluster
# = = = = = = = = = = = = = = = = = = = = = =

resource "google_container_cluster" "cluster-staging" {
  project            = "${var.project}"
  name               = "${var.cluster_staging_name}"
  zone               = "${var.zone}"
  enable_legacy_abac = true
  initial_node_count = 1

  master_auth {
    username = "${var.cluster_staging_username}"
    password = "${var.cluster_staging_password}"
  }

  node_config {
    machine_type = "n1-standard-2"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    tags = ["cluster-staging"]
  }
}

# = = = = = = = = = = = = = = = = = = = = = = 
# disk
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_disk" "cluster-staging" {
  name  = "cluster-staging-disk"
  type  = "pd-standard"
  zone  = "${var.zone}"
  size  = "20"
  image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20180613"
  labels {
    environment = "cluster-staging"
  }
}
