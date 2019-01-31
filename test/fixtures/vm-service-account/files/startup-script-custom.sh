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

set -e

BUCKET="$(stdlib::metadata_get -k instance/attributes/bucket)"
BASEDIR="$(readlink -f ~terraform)"
PROJECT_FACTORY="$BASEDIR/project-factory"

cd "$BASEDIR" || exit 1

stdlib::info "Fetching and unpacking Project Factory artifacts"
stdlib::cmd gsutil cp -r "gs://$BUCKET/*" "$BASEDIR"

stdlib::cmd tar -xf project-factory.tar
cd project-factory || exit 1

stdlib::info "Installing Terraform and Project Factory dependencies"
stdlib::cmd sudo -u terraform -i "$PROJECT_FACTORY/helpers/init_debian.sh"
stdlib::cmd chown -R terraform:terraform "$BASEDIR"

stdlib::cmd touch /tmp/setup_complete
