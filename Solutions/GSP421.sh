


curl -LO https://github.com/tariqsheikhsw/GoogleCloudArchitectLabs/blob/main/Solutions/GSP421/demo-image1.png
curl -LO https://github.com/tariqsheikhsw/GoogleCloudArchitectLabs/blob/main/Solutions/GSP421/demo-image2.png

gcloud alpha services api-keys create --display-name="lab"  
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=lab") 
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)") 
echo $API_KEY

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil mb gs://$DEVSHELL_PROJECT_ID-lab

gsutil cp demo-image1.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image2.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image1-copy.png gs://$DEVSHELL_PROJECT_ID-lab
