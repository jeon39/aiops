#!/bin/bash

# 환경 변수 설정
export MLFLOW_DB_URI="postgresql+psycopg2://genai:genai1234%21%40%23%24@10.50.62.159:20159/mlflow"
export ROOT_PATH="/your/root/path"  # 필요 시 절대경로로 수정

# 컨테이너 이름
ROOT_PATH="$(cd "$(dirname "$0")" && pwd)"
echo "이 스크립트가 위치한 Dir : $ROOT_PATH"

# 1. 기존 컨테이너 중지 및 제거
echo "컨테이너를 중지합니다. : $CONTAINER_NAME"
docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

# 2. 재시작
echo "컨테이너를 재시작합니다.: $CONTAINER_NAME"
docker run -it -p 8894:5000 --rm \
  --env MLFLOW_DB_URI=$MLFLOW_DB_URI \
  --shm-size=16G \
  -v $ROOT_PATH/mlflow/scripts:/mlflow/scripts \
  -v $ROOT_PATH/mlflow/logs:/mlflow/logs \
  -v /artifacts/models:/mlflow/artifacts \
  --name $CONTAINER_NAME \
  spansite/aiops:mlflow-triton_v2 \
  bash -c "\
  mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --backend-store-uri \$MLFLOW_DB_URI \
    --default-artifact-root /mlflow/artifacts & \
  exec bash"
