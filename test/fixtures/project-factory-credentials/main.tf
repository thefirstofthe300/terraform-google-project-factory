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

provider "google" {
  version = "~> 1.20"
}

provider "google-beta" {
  #credentials = "${file(local.credentials_file_path)}"
  version = "~> 1.20"
}

resource "random_id" "main" {
  byte_length = 4
}

locals {
  suffix                  = "${random_id.main.hex}"
  project_factory_archive = "${path.module}/files/project-factory.tar"
  remote_credentials_path = "../../../credentials.json"
  terraform_user          = "terraform"
}

resource "google_service_account_key" "main" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"
}
