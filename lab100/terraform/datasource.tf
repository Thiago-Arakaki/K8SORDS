data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.compartment_ocid}"
}
 
# https://www.terraform.io/docs/providers/oci/d/core_images.html
data "oci_core_images" "oracle_linux_image" {
  compartment_id           = "${var.compartment_ocid}"
  operating_system         = "Oracle Linux"
  operating_system_version = "7.6"
}