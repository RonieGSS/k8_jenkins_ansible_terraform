# = = = = = = = = = = = = = = = = = = = = = = 
# IP & DNS
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_dns_record_set" "ci-template-sidekick-tokyo" {
  name = "ci.${var.template_sidekick_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_sidekick_zone}"
  rrdatas = ["${var.ip_for_compute-ci}"]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# Firewall
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_firewall" "compute-ci" {
  name    = "compute-ci"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  allow {
    protocol = "udp"
    ports    = ["65000", "65001", "65002"]
  }
  target_tags = ["${google_compute_instance.compute-ci.tags}"]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# instance
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_instance" "compute-ci" {
  name         = "compute-ci"
  zone         = "${var.zone}"
  machine_type = "n1-highcpu-4"

  tags = ["compute-ci"]

  boot_disk {
    auto_delete = "false"
    source      = "${google_compute_disk.compute-ci.self_link}"
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${var.ip_for_compute-ci}"
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
  metadata {
    block-project-ssh-keys = "true"
    ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
  }

  # Install python2 for Ansible
  # https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#managed-node-requirements
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "user"
      private_key = "${file(var.ssh_private_key_path)}"
    }
    inline = [
      "sudo apt-get install -y python",
    ]
  }
}


# = = = = = = = = = = = = = = = = = = = = = = 
# disk
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_disk" "compute-ci" {
  name  = "template-compute-ci-disk"
  type  = "pd-standard"
  zone  = "${var.zone}"
  size  = "20"
  image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20180613"
  labels {
    environment = "compute-ci"
  }
}
