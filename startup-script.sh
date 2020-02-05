#!/bin/bash
apt-get update
apt-get install -y git
apt-get install -y python-pip
apt-get install -y virtualenv
apt-get update
git clone https://github.com/dowjones/factiva-streams-python.git /opt/factiva-stream-client
virtualenv -p /usr/bin/python3 /opt/factiva-stream-client/venv
source /opt/factiva-stream-client/venv/bin/activate
pip install -r /opt/factiva-stream-client/requirements.txt
export SUBSCRIPTION_ID="SUBSCRIPTION_ID"
export USER_KEY="USER_KEY"
export GCP_PROJECT_ID="GCP_PROJECT_ID"
export GCP_PUBSUB_TOPIC="GCP_PUBSUB_TOPIC"
python /opt/factiva-stream-client/fs_to_gcp_pubsub.py
