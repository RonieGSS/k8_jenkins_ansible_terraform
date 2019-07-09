# = = = = = = = = = = = = = = = = = = = = = = 
# IP & DNS
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_dns_record_set" "log-template-sidekick-tokyo" {
  name = "log.${var.template_sidekick_dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.template_sidekick_zone}"
  rrdatas = ["${var.ip_for_compute-log}"]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# Firewall
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_firewall" "compute-log" {
  name    = "compute-log"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  allow {
    protocol = "udp"
    ports    = ["60000", "60001", "60002"]
  }
  target_tags = ["${google_compute_instance.compute-log.tags}"]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# instance
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_instance" "compute-log" {
  name         = "compute-log"
  zone         = "${var.zone}"
  machine_type = "${var.machine_type}"

  tags = ["compute-log"]

  boot_disk {
    auto_delete = "false"
    source      = "${google_compute_disk.compute-log.self_link}"
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${var.ip_for_compute-log}"
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

resource "google_compute_disk" "compute-log" {
  name  = "template-compute-log-disk"
  type  = "pd-standard"
  zone  = "${var.zone}"
  size  = "20"
  image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20180613"
  labels {
    environment = "compute-log"
  }
}
