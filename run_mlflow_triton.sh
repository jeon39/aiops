#!/bin/bash

#ROOT_PATH=/data/env
ROOT_PATH="$(cd "$(dirname "$0")" && pwd)"

echo "이 스크립트가 위치한 Dir : $ROOT_PATH"

##   
docker run -it -p 8894:5000 \
--shm-size=16G --restart always \
-v $ROOT_PATH/mlops/scripts:/mlflow/utils/sh \
-v $ROOT_PATH/mlflow/backup/logs:/mlflow/utils/logs \
-v $ROOT_PATH/mlflow/backup/db:/mlflow/db \
-v $ROOT_PATH/mlflow/mlflow/models:/artifacts/mlflow/models \
--name mlflow-triton \
spansite/aiops:mlflow-triton_v1 /bin/bash
