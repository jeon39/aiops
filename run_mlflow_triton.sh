#!/bin/bash
# genai1234!%40#$'@10.50.62.159:20159/mlflow
export MLFLOW_DB_URI="postgresql+psycopg2://genai:'genai1234%21%40%23%24'@10.50.62.159:20159/mlflow"

#ROOT_PATH=/aiops
ROOT_PATH="$(cd "$(dirname "$0")" && pwd)"

echo "이 스크립트가 위치한 Dir : $ROOT_PATH"

## 설명
# 1. sqlite -> pgsql 로 변경 : sqlite:////mlflow/db/mlflow.db -> 아래와 같이 변경하였음
#   - postgresql+psycopg2://'db 유저 id':'db 비번'@'db 호스트':'db 포트번호'/'데이터 저장할 db이름'
# 2. /artifacts/models 는 실제 서버의 디렉토리이며 대규모 아티팩트 저장을 위해 NAS로 연결되었음. 여기에 컨테이너의 /mlflow/artifacts 를 마운트하였음 
docker run -it -p 8894:5000 --rm \
--env MLFLOW_DB_URI=$MLFLOW_DB_URI \
--shm-size=16G \
-v $ROOT_PATH/mlflow/scripts:/mlflow/scripts \
-v $ROOT_PATH/mlflow/logs:/mlflow/logs \
-v $ROOT_PATH/artifacts/models:/mlflow/artifacts \
--name mlflow-triton \
spansite/aiops:mlflow-triton_v2 \
bash -c "\
mlflow server \
  --host 0.0.0.0 \
  --port 5000 \
  --backend-store-uri \$MLFLOW_DB_URI \
  --default-artifact-root /mlflow/artifacts & \
exec bash"