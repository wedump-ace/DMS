#!/bin/bash

email=$1
password=$2
atype=$3 # "PROJECT" OR "TASK"
project_id=$4

auth_ret=$(curl -s -X POST -d "{\"email\": \"$email\", \"password\": \"$password\"}" -H "Content-Type: application/json" http://localhost:9990/api/v1/mng/users/authorizations/)
jwt_token=$(echo $auth_ret | sed "s/{.*\"jwt_token\":\"\([^\"]*\).*}/\1/g")


if [[ $atype == "PROJECT" ]]; then
	ret=$(curl -s -H "Authorization: Bearer $jwt_token" "http://175.124.226.229:9990/api/v1/mng/projects/?page_num=0&page_size=999&sort_key=created_at&sort_order=desc&org_id=cNmgJfhWG4ewMsgqAQsE00")
	echo $ret | grep -Po '"id":".+?","name":".+?"'
fi
if [[ $atype == "TASK" ]]; then
	ret=$(curl -s -H "Authorization: Bearer $jwt_token" "http://175.124.226.229:9990/api/v1/mng/projects/$project_id/tasks/?page_num=0&page_size=999&sort_key=created_at&sort_order=desc")
	echo $ret | grep -Po '"id":".+?".+?"name":".+?"' | grep -v metric
fi
