# 1. Docker build (수동 빌드)
docker build --platform=linux/amd64 -t iris-classifier-image .

# 2. Conda 환경 준비 (수동으로 미리 생성, aiops)
& "$env:USERPROFILE\anaconda3\shell\condabin\conda-hook.ps1"    # Conda 경로는 환경에 맞게 수정할 것
conda activate aiops

# 3. MLflow Tracking URI
$env:MLFLOW_TRACKING_URI = "http://[Mlflow Server IP]:[Port]"
$env:PYTHONUTF8 = 1

# 4. MLflow run (Experiment, Run Name  지정)
mlflow run . --experiment-name "seongj" --run-name "random-forest-v3"   #experiment-name, run-name은 수정 가능"
