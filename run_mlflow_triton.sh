#!/bin/bash

#ROOT_PATH=/aiops
ROOT_PATH="$(cd "$(dirname "$0")" && pwd)"

echo "이 스크립트가 위치한 Dir : $ROOT_PATH"

##   
docker run -it -p 8894:5000 \
--shm-size=16G --restart always \
-v $ROOT_PATH/scripts:/mlflow/sh \
-v $ROOT_PATH/mlflow/logs:/mlflow/logs \
-v $ROOT_PATH/mlflow/db:/mlflow/db \
-v $ROOT_PATH/mlflow/artifacts:/artifacts \
--name mlflow-triton \
spansite/aiops:mlflow-triton_v1 /bin/bash
