# = = = = = = = = = = = = = = = = = = = = = =
# Kubernetes Outputs
# = = = = = = = = = = = = = = = = = = = = = =

output "production_client_certificate" {
  value = "${google_container_cluster.cluster-production.master_auth.0.client_certificate}"
}

output "production_client_key" {
  value = "${google_container_cluster.cluster-production.master_auth.0.client_key}"
}

output "production_cluster_ca_certificate" {
  value = "${google_container_cluster.cluster-production.master_auth.0.cluster_ca_certificate}"
}

output "staging_client_certificate" {
  value = "${google_container_cluster.cluster-staging.master_auth.0.client_certificate}"
}

output "staging_client_key" {
  value = "${google_container_cluster.cluster-staging.master_auth.0.client_key}"
}

output "staging_cluster_ca_certificate" {
  value = "${google_container_cluster.cluster-staging.master_auth.0.cluster_ca_certificate}"
}