# 1. Docker build (수동 빌드)
docker build --platform=linux/amd64 -t iris-classifier-image .

# 2. Conda 환경 준비
& "$env:USERPROFILE\anaconda3\shell\condabin\conda-hook.ps1"
conda activate aiops

# 3. MLflow Tracking URI
$env:MLFLOW_TRACKING_URI = "http://10.50.62.185:8894"
$env:PYTHONUTF8 = 1

# 4. MLflow run (Run Name 미지정)
#mlflow run .

# 5. Run Name 변경 실행시
mlflow run . -P run_name="random-forest-v1"
