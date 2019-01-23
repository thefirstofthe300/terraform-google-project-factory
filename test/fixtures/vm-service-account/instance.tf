/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "startup-script-lib" {
  source = "github.com/terraform-google-modules/terraform-google-startup-scripts"
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = "${tls_private_key.main.private_key_pem}"
  filename = "${path.module}/ssh/key"
}

resource "google_compute_instance" "main" {
  name         = "vm-service-account-${local.suffix}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  project      = "${var.project_id}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "${var.network}"

    access_config {}
  }

  metadata {
    sshKeys               = "${local.terraform_user}:${tls_private_key.main.public_key_openssh}"
    startup-script        = "${module.startup-script-lib.content}"
    startup-script-custom = "${file("${path.module}/files/startup-script-custom.sh")}"
    bucket                = "${google_storage_bucket.main.name}"
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}

resource "null_resource" "wait_for_jenkins_configuration" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-vm.sh ${var.project_id} ${google_compute_instance.main.zone} ${google_compute_instance.main.name}"
  }

  depends_on = ["google_compute_instance.main"]
}
