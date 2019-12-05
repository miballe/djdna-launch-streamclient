#!/bin/bash
apt-get update
apt-get install -y git
apt-get install -y python-pip
apt-get install -y virtualenv
apt-get update
git clone https://github.com/miballe/dj-dna-streams-python.git /opt/dna-stream-client
virtualenv -p /usr/bin/python3 /opt/dna-stream-client/venv
source /opt/dna-stream-client/venv/bin/activate
pip install -r /opt/dna-stream-client/requirements.txt
python /opt/dna-stream-client/setup.py install
mkdir /opt/dna-stream-client/dnaStreaming/articles
export SUBSCRIPTION_ID="SUBSCRIPTION_ID"
export USER_KEY="USER_KEY"
cd /opt/dna-stream-client
python /opt/dna-stream-client/setup.py install
python ./dnaStreaming/demo/show_stream.py -s
