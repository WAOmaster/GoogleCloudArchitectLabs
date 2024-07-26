//Task3 - USER2

USER=student-03-0281273a3d8b@qwiklabs.net


cat > service_account.py <<EOF
import json
def fetch_sa():
    f = open('conn.json')
    data = json.load(f)

    print(str(data[0]['cloudResource']['serviceAccountId']))
if __name__ == '__main__':
    fetch_sa()
EOF

export PROJECT_ID=$(gcloud config get-value project)
gcloud services enable bigqueryconnection.googleapis.com
bq mk --connection --location=US --project_id=$PROJECT_ID \
    --connection_type=CLOUD_RESOURCE user_data_connection

bq ls --connection --project_id=$PROJECT_ID --location=US --filter "type=CLOUD_RESOURCE" --format=prettyjson > conn.json
serviceAccount=$(python service_account.py)

gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member="serviceAccount:${serviceAccount}" \
      --role='roles/storage.objectViewer'

bq mk online_shop

bq mkdef --connection_id=$PROJECT_ID.US.user_data_connection --source_format=CSV --autodetect=true \
  gs://$PROJECT_ID-bucket/user-online-sessions.csv > mytable_def1

bq mk --table --external_table_definition=mytable_def1 \
  online_shop.user_online_sessions

gcloud projects remove-iam-policy-binding $PROJECT_ID \
      --member="user:${USER}" \
      --role='roles/storage.objectViewer'

echo "---------------------"
echo "BIGQUERY LINK : https://console.cloud.google.com/bigquery?project=$DEVSHELL_PROJECT_ID"
echo "---------------------"



#----BACK TO TERMINAL > REPLACE PROJECT ID------
bq query --use_legacy_sql=false \
'SELECT *  EXCEPT(zip, latitude, ip_address, longitude)
FROM `qwiklabs-gcp-02-e2ea5232bafe.online_shop.user_online_sessions`;'
