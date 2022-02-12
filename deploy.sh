#! /bin/bash

set -e

echo "Building..."
docker build -t danbruder/stripes:latest .

echo "Pushing..."
docker push danbruder/stripes:latest

echo "Deploying..."
caprover deploy -i danbruder/stripes:latest -a list -n captain-01
