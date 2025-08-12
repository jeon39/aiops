#!/bin/bash
# Sqllit :  -v $ROOT_PATH/mlflow/db 를 추가한 후, sqlite:////mlflow/db/mlflow.db를 추가
export MLFLOW_DB_URI="postgresql+psycopg2://[ID]:[PWD]@[PGSql Server IP]:[Port]/[DB Name]"

#ROOT_PATH=/aiops <- 스크립스 시작 위치
ROOT_PATH="$(cd "$(dirname "$0")" && pwd)"

echo "이 스크립트가 위치한 Dir : $ROOT_PATH"

## 설명
# 1. sqlite -> pgsql 로 변경 : sqlite:////mlflow/db/mlflow.db -> 아래와 같이 변경하였음
#   - postgresql+psycopg2://'db 유저 id':'db 비번'@'db 호스트':'db 포트번호'/'데이터 저장할 db이름'
# 2. /artifacts/models 는 실제 서버의 디렉토리(NAS)이며 대규모 아티팩트 저장을 위해 NAS로 연결되었음. 여기에 컨테이너의 /mlflow/artifacts 를 마운트하였음
# 3. 백그라운드 실행 : docker run -d -p 8894:5000 --restart always \
# 4. 아티팩트저장 : $ROOT_PATH/models/[run_id]/[docker_id]/artifacts (이 경로 아래에 model, reports 디렉토리에 저장됨)
#                 - modle : conda.yaml, metadata, MLmodel, model.pkl, python_env.yaml, requirements.txt
#                 - reports : predeictions.csv
docker run -it -p 8894:5000 --rm \
--env MLFLOW_DB_URI=$MLFLOW_DB_URI \
--shm-size=16G \
-v $ROOT_PATH/mlflow/scripts:/mlflow/scripts \
-v $ROOT_PATH/mlflow/logs:/mlflow/logs \
-v $ROOT_PATH/models:/mlflow/artifacts \
--name mlflow-triton \
spansite/aiops:mlflow-triton_v2 \
bash -c "\
mlflow server \
  --host 0.0.0.0 \
  --port 5000 \
  --backend-store-uri \$MLFLOW_DB_URI \
  --default-artifact-root /mlflow/artifacts & \
exec bash"