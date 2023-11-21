#!/bin/bash
# Copyright 2023 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# Create mount dir.
mount_dir=$WORKING_DIR/gcs
mkdir -p $mount_dir

if mountpoint -q -- "$mount_dir"; then
  echo "Unmounting previous mount..."
  umount $mount_dir
fi

bucket_name=princer-read-cache-load-test

# Generate yml config.
export MAX_SIZE_IN_MB="${1:-100}"
export DOWNLOAD_FOR_RANDOM_READ="${2:-True}"
./generate_yml_config.sh

# Mount gcsfuse
echo "Mounting gcsfuse..."
gcsfuse --stackdriver-export-interval 30s --debug_fuse --log-file $WORKING_DIR/gcsfuse_logs.txt --log-format text --config-file ./config.yml $bucket_name $mount_dir
