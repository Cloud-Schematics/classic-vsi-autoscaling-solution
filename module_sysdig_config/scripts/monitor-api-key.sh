ACCESS_TOKEN=$1                 # IBM Cloud access token
SYSDIG_INSTANCE_ID=$2           # sysdig monitor instance id
 
output=$(curl -X GET \
    "https://us-south.monitoring.cloud.ibm.com/api/token" \
    -H "Authorization: $ACCESS_TOKEN" \
    -H "IBMInstanceID: $SYSDIG_INSTANCE_ID")

API_TOKEN=$(echo $output | jq '.token.key' | sed -e 's/^"//' -e 's/"$//')

jq -n --arg api_key $API_TOKEN \
        '{
          "api_key":$api_key,
        }'