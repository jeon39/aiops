# 1. Docker build (수동 빌드)
#docker build --no-cache --platform=linux/amd64 -t iris-classifier-image .  # 캐시 사용안하고 새로 빌드
docker build --platform=linux/amd64 -t iris-classifier-image .   # 캐시 사용, 수정사항 없으면 기존 이미지 사용

# 2. Conda 환경 준비
& "$env:USERPROFILE\anaconda3\shell\condabin\conda-hook.ps1"
conda activate aiops

# 3. MLflow Tracking URI
$env:MLFLOW_TRACKING_URI = "http://10.50.62.185:8894"
$env:PYTHONUTF8 = 1

# 4. MLflow run (Experiment, Run Name  지정)
mlflow run . --experiment-name "seongj" --run-name "random-forest-v6"
