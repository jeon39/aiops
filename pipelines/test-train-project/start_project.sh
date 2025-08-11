# export MLFLOW_TRACKING_URI=http://host.docker.internal:8894   # docker 내부 접속 시
export MLFLOW_TRACKING_URI=http://[MLflow Server IP]:[Port]

# 4. MLflow run (Experiment, Run Name  지정)
mlflow run . --experiment-name "seongj" --run-name "random-forest-v3"   #experiment-name, run-name은 수정 가능"
