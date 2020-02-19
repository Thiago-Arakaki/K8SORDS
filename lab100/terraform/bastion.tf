//Temporary key for remote-exec resource
resource "tls_private_key" "public_private_key_pair" {
  algorithm   = "RSA"
}

resource "oci_core_instance" "bastion" {
depends_on = ["oci_containerengine_node_pool.k8s_node_pool"]
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.availability_domains -3],"name")}"
  compartment_id = "${oci_identity_compartment.oke_compartment.id}"
  display_name = "vm-bastion"
  shape = "VM.Standard2.2"
  subnet_id = "${oci_core_subnet.workerSubnetAD1.id}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key_pub}\n${tls_private_key.public_private_key_pair.public_key_openssh}" //The second key is a temporary one for the "remote-exec" resource
/*    user_data = "${base64encode(file(var.bootstrap_file))}"   //The commands were placed at a remote-exec resource instead
    assign_public_ip = "false"  */
  }

  source_details {
    source_type = "image"
    source_id = "${var.instance_image_ocid[var.region]}"
  }
}

//The next block is made just for this Workshop and does not correspond to a security best practice
resource "null_resource" "remote-exec" {
  depends_on = ["oci_core_instance.bastion"]

    connection {
      agent = false
      timeout = "30m"
      host = "${oci_core_instance.bastion.public_ip}"
      user = "opc"
      private_key = "${tls_private_key.public_private_key_pair.private_key_pem}"
    }

  provisioner "remote-exec" {
 inline = [
      "sudo yum install python-oci-cli kubectl git -y",
      "sudo systemctl enable ocid.service",
      "sudo systemctl start ocid.service",
      "sudo systemctl status ocid.service",
      //Creation of default directory for OCI CLI configuration and files
      "mkdir -p ~/.oci/",
      "mkdir -p $HOME/.kube",
      //Create the default configuration file
      "touch ~/.oci/config",
      //Insert the Workshop default information
      "echo [DEFAULT] >> ~/.oci/config",
      "echo user=${var.user_id} >> ~/.oci/config", //It's not a best practice to have de User OCID as a variable - Workshop use only
      "echo fingerprint=2d:b9:0f:d1:0d:07:1c:a7:d2:ad:47:8e:fc:7c:18:80 >> ~/.oci/config", //Figerprint for Workshop Public PEM Key - Workshop use only
      "echo key_file=~/.oci/oci_api_key.pem >> ~/.oci/config",
      "echo tenancy=${var.tenancy_ocid} >> ~/.oci/config",
      "echo region=${var.region} >> ~/.oci/config",
      "echo compartment=${var.compartment_ocid} >> ~/.oci/config",
      "oci setup repair-file-permissions --file ~/.oci/config",
      "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.k8s_cluster.id} --file $HOME/.kube/config --region us-ashburn-1 --token-version 2.0.0",
      "sudo systemctl disable firewalld",
      "sudo systemctl stop firewalld",
      "git clone https://github.com/gustavogaspar/assets.git",
      "cp ~/assets/oci_api_key.pem ~/.oci/oci_api_key.pem",
      "export KUBECONFIG=$HOME/.kube/config",
      "kubectl apply -f ~/assets/oke-admin.yaml",
      "kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep oke-admin | awk '{print $1}') >> token.txt",
      "cat token.txt"
]
  }


}