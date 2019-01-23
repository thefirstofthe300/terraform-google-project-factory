#!/bin/bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Wait for the vm-service-account instance to boot and install dependencies

set -u

PROJECT=$1
ZONE=$2
INSTANCE_NAME=$3
COMMAND="ls /etc/profile.d/environment.sh"

echo "Waiting for instance ${INSTANCE_NAME} in project ${PROJECT} to complete..."

gcloud compute --project "${PROJECT}" ssh "terraform@${INSTANCE_NAME}" --zone "${ZONE}" --command="${COMMAND}" --force-key-file-overwrite 2>/dev/null
rc=$?

while [[ "${rc}" -ne "0" ]]; do
    printf "."
    sleep 5
    gcloud compute --project "${PROJECT}" ssh "terraform@${INSTANCE_NAME}" --zone "${ZONE}" --command="${COMMAND}" --force-key-file-overwrite 2>/dev/null
    rc=$?
done

echo "Instance is ready!"
