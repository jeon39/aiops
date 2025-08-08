# export MLFLOW_TRACKING_URI=http://host.docker.internal:8894   # docker 내부 접속 시
export MLFLOW_TRACKING_URI=http://http://10.50.62.185:8894

mlflow run . --env-manager docker
