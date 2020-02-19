output "kube-token" {
  value = "${data.oci_containerengine_cluster_kube_config.cluster_kube_config.content}"
}