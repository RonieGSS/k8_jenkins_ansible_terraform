
# = = = = = = = = = = = = = = = = = = = = = = 
# Kubernetes Provider
#
# Change to staging arguments
# to update staging cluster 
# Comment out production secrets
# and uncomment staging secrets
# = = = = = = = = = = = = = = = = = = = = = = 

provider "kubernetes" {
  host  = "${google_container_cluster.cluster-production.endpoint}"

  client_certificate     = "${base64decode(google_container_cluster.cluster-production.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.cluster-production.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.cluster-production.master_auth.0.cluster_ca_certificate)}"
}
