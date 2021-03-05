#!/bin/bash
apt-get update
apt-get install -y git
apt-get install -y python-pip
apt-get install -y virtualenv
apt-get update
git clone https://github.com/dowjones/dj-dna-streams-python.git /opt/factiva-stream-client
virtualenv -p /usr/bin/python3 /opt/factiva-stream-client/venv
source /opt/factiva-stream-client/venv/bin/activate
cd /opt/factiva-stream-client
pip install -r requirements.txt
python setup.py install
gcloud iam service-accounts keys create /opt/factiva-stream-client/svcacc.json --iam-account=factiva-service@dj-pib-slt-hackathon-team1.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS="/opt/factiva-stream-client/svcacc.json"
export SUBSCRIPTION_ID="SUBSCRIPTION_ID"
export USER_KEY="USER_KEY"
export GCP_PROJECT_ID="GCP_PROJECT_ID"
export GCP_PUBSUB_TOPIC="GCP_PUBSUB_TOPIC"
python /opt/factiva-stream-client/dnaStreaming/demo/pubsub_stream.py
