#!/bin/sh

tries=0
while [ "$tries" -lt 3 ]
do
     ip=$(curl -s https://ifconfig.me)
     valid=$(echo ${ip} | grep -E '([0-9]{1,3}\.?){4}')
     if [ "${valid}" ]; then
          break
     fi
     tries=$(expr $tries + 1)
     sleep 1
done

if ! [ "${valid}" ]; then
     echo "unable to get ip"
     exit 1
fi

zone_id=$(curl -s "https://api.cloudflare.com/client/v4/zones?name=${ZONE_NAME}" \
     -H "Authorization: Bearer ${AUTH_TOKEN}" \
     -H "Content-Type: application/json" | jq -r '.result[0].id')

record_id=$(curl -s "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records?name=${ZONE_NAME}&type=A" \
     -H "Authorization: Bearer ${AUTH_TOKEN}" \
     -H "Content-Type: application/json" | jq -r '.result[0].id')

curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${record_id}" \
     -H "Authorization: Bearer ${AUTH_TOKEN}" \
     -H "Content-Type: application/json" \
     --data '{"content":"'${ip}'"}'
