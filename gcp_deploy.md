# Deploy a Stream Client to GCP

The deployment of a GCP requires to first define a common identity across all services to be used with the aim to have control on who has access to each resource and keep consistency for all services.

## Prerequisites

This guide asumes the following conditions are met before starting with the step 1.

* You have a valid API-Key for Factiva Streams
* A Factiva Stream is already created and you know its SUBSCRIPTION_ID
* A GCP Project exists. For the sake of simplicity, this guide asumes you're workin in a brand new GCP Project.

## 1. Create a Service Account

[Create a GCP service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts#creating) and [grant](https://cloud.google.com/iam/docs/granting-roles-to-service-accounts#granting_access_to_a_service_account_for_a_resource) the following roles. For reference, in this and other associated documents this user is called **factiva-service@projectid.iam.gserviceaccount.com**.

* Pub/Sub Publisher
* Cloud Datastore User (if main repository resides in Cloud Datastore)

It is not necessary to create a service key, unless you expect to use the same credentials when debugging outside of GCP.

## 2. Check or enable GCP APIs

The following APIs are required to be [enabled](https://cloud.google.com/endpoints/docs/openapi/enable-api) in the GCP Project.

* Compute Engine API
* Cloud Pub/Sub API
* Cloud Functions API
* Cloud Datastore API

## 3. Create a Pub/Sub Topic

It is known that Stream articles are delivered using a Pub/Sub topic located in the Dow Jones infrastructure. The aim of [creating a new topic](https://cloud.google.com/pubsub/docs/admin#creating_a_topic) is to enable different document flows. These flows are useful when separating production/staging/development environments, or when documents have to follow parallel processing pipelines.

For reference, this guide will use the name "**TradingNews**"

## 4. Create a Cloud Function

Create a Cloud Function that will be triggered each time a new message arrives to the previously created Pub/Sub topic (TradingNews). Use the code available in the repository [factiva-streamclient-launch](https://github.com/dowjones/factiva-streamclient-launch), choosing the code file according to the destination database.

In this guide, we'll use the code in the function [to_datastore_X](https://github.com/dowjones/factiva-streamclient-launch). The code is quite simple and the GCP UI can be used for this purpose. To customise the code and keep track of changes, it is recommended to switch to a code control tool.

For reference, this guide uses the following function settings:

* Name: process-tradingnews
* Memory allocated: 128 MB
* Trigger: Cloud Pub/Sub
* Topic: TradingNews
* Source code: Inline
* Runtime: Python 3.7
* main.py: Code in [to_datastore_function.py](https://raw.githubusercontent.com/dowjones/factiva-streamclient-launch/master/to_datastore_function.py)
* requirements.txt: [to_datastore_requirements.txt](https://raw.githubusercontent.com/dowjones/factiva-streamclient-launch/master/to_datastore_requirements.txt)
* Function to execute: process_message
* Advanced Options:
  * Service Account: *factiva-service@projectid.iam.gserviceaccount.com* (Created in step 1)
  * Change other settings according to your environment and needs. E.g. Region is a key settings to avoid unecessary data transfers among GCP regions.

## 5. Create a Compute Engine instance

Create a new VM instance with the following details.

* Name: e.g. factiva-stream-client
* Region/Zone: Choose a convenient location. Ideally, the same one chosen for the Cloud Function.
* Machine Configuration: General-Purpose > N1 > f1-micro (this size is commonly enough for the expected workload)
* Boot disk: Debian GNU/Linux 10 (buster) - It's important to select Debian 10 since this image is the one running Python 3.7. Otherwhise you may need to follow additional steps to have this prerequisite.
* Identity and API access > Service Account: *factiva-service@projectid.iam.gserviceaccount.com* (Created in step 1)
* Expand the section "Management, security, disks, networking, sole tenancy
* Management > Automation > Startup script: Add the contents of the sample [start script](https://raw.githubusercontent.com/dowjones/factiva-streamclient-launch/master/startup-script.sh). **Don't forget to change the environment values to the appropriate values as per your configuration **
* Keep all other values as default

After one or two minutes you'll start seeing data entries in Cloud Datastore.
