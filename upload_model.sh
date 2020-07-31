#!/bin/bash

email=$1
password=$2

project_id=$3
task_id=$4

model_file_path=$5
schema_file_path=$6
weight_file_path=$7

model_name=$(echo "$model_file_path" | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}')
framework_type=5 # Tensorflow2

auth_ret=$(curl -s -X POST -d "{\"email\": \"$email\", \"password\": \"$password\"}" -H "Content-Type: application/json" http://localhost:9990/api/v1/mng/users/authorizations/)
jwt_token=$(echo $auth_ret | sed "s/{.*\"jwt_token\":\"\([^\"]*\).*}/\1/g")

if [ -z "$weight_file_path" ]; then
	curl -s -X POST -F "name=$model_name" -F "model_file=@$model_file_path" -F "schema_file=@$schema_file_path" -F "model_framework_type=$framework_type" -H "Content-Type: multipart/form-data" -H "Authorization: Bearer $jwt_token" http://localhost:9990/api/v1/mng/projects/$project_id/tasks/$task_id/models/
else
	curl -s -X POST -F "name=$model_name" -F "model_file=@$model_file_path" -F "schema_file=@$schema_file_path" -F "weight_file=@$weight_file_path" -F "model_framework_type=$framework_type" -H "Content-Type: multipart/form-data" -H "Authorization: Bearer $jwt_token" http://localhost:9990/api/v1/mng/projects/$project_id/tasks/$task_id/models/
fi
