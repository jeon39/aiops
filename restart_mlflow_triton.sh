#!/bin/bash

# 환경 변수 설정
export MLFLOW_DB_URI="postgresql+psycopg2://[ID]:[PWD]@[PGSql Server IP]:[Port]/[DB Name]"
export ROOT_PATH="$(cd "$(dirname "$0")" && pwd)"
echo "이 스크립트가 위치한 Dir : $ROOT_PATH"

# 컨테이너 이름
CONTAINER_NAME="mlflow-triton"

# 1. 기존 컨테이너 중지 및 제거
echo "컨테이너를 중지합니다. : $CONTAINER_NAME"
docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

# 2. 재시작
echo "컨테이너를 재시작합니다.: $CONTAINER_NAME"
# 백그라운드 실행 : docker run -d -p 8894:5000 --restart always \
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
