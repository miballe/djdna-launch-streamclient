import base64
import json
from google.cloud import datastore

ds_client = datastore.Client()


def process_message(event, context):
    """Triggered from a message on a Cloud Pub/Sub topic.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    msg_obj = json.loads(pubsub_message)
    key = ds_client.key('newsarticle', msg_obj['an'])
    entity = datastore.Entity(key=key, exclude_from_indexes=['body', 'snippet'])
    entity.update(msg_obj)
    ds_client.put(entity)
    return True
