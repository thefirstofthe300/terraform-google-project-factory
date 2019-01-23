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

output "instance_name" {
  description = "The GCP instance name"
  value       = "${google_compute_instance.main.name}"
}

output "instance_ip" {
  description = "The GCP instance external IP address"
  value       = "${google_compute_instance.main.network_interface.0.access_config.0.nat_ip}"
}

output "bucket" {
  description = "The GCS bucket containing the Project Factory test artifacts"
  value       = "${google_storage_bucket.main.name}"
}
