resource "oci_database_autonomous_database" "workshopATP" {
    #Required
    admin_password = "${var.db_password}"
    compartment_id = "${oci_identity_compartment.oke_compartment.id}"
    cpu_core_count = "1"
    data_storage_size_in_tbs = "1"
    db_name = "workshopATP"

    #Optional
    db_workload = "OLTP"
    display_name = "workshopATP"
}