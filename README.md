# MLflow + Docker + Remote Tracking Server (Iris-Classifier)

이 프로젝트는 **MLflow**를 활용하여 `iris` 데이터셋을 학습하고,  
원격 MLflow Tracking Server(리눅스) + 로컬 개발 환경(Windows, VSCode, Docker)에서  
실험 메타데이터, 모델, CSV 아티팩트를 관리하는 예제입니다.

---

## MLproject 프로젝트 구성 (Iris-Classifier 학습)

```
.
├── Dockerfile                # MLprject를 실행할 도커 파일
├── MLproject                 # MLflow Project 를 도커에서 실행하기 위한 설정 파일
├── train.py                  # 모델 학습, 메트릭/아티팩트 로깅
├── start_project.ps1         # Windows에서 원격 MLflow Traking 서버로 '실험' 개시를 요청하는 파워쉘 스크립트
└── README.md
```

---

## ⚙️ 환경 구성

### 1. MLflow Tracking Server (리눅스 서버)
- 실행 : start_mlflow_triton.sh
- ROOT_PATH : start_mlflow_triton.sh 실행위치
- 아티팩트 저장 : ROOT_PATH/experiments (NAS 마운트 등 경로 변경 가능, Permission 주의)
- Docker 실행 예:

> 📂 **Artifact Store**: Tracking 서버 `$ROOT_PATH/experiments`  
> 예: `$ROOT_PATH/experiments/<experiment_id>/<run_id>/`

---

### 2. MLproject 실행 환경 (Windows + VSCode)
- Conda 환경: `aiops` (변경 가능)
- Docker Desktop (Linux 컨테이너 모드)
- MLflow CLI 설치 (`pip install mlflow`)

---

## 🚀 실행 방법

### 1. MLproject를 실행할 서버 도커 이미지를 미리(수동) 빌드한다.
```powershell
docker build --platform=linux/amd64 -t iris-classifier-image .
```

### 2. MLproject의 Tracking URI 설정
```start_projects.ps1
$env:MLFLOW_TRACKING_URI = "http://<remote-server-ip>:8894"
$env:PYTHONUTF8 = 1
```

### 3. MLproject 실행 설정
```start_projects.ps1
mlflow run . --experiment-name "seongj-2" --run-name "random-forest-v2"
```
- `--experiment-name` : 실험 이름 (없으면 자동 생성)
- `--run-name` : 런 이름

> **(주의)**실험이 삭제 상태(`deleted`)라면 실행 전 복구 필요: (coda 등 mlflow 클라이언트가 설치된 환경에서 실행)
```restore_experiment.ps1
mlflow experiments restore --experiment-id <experiment_id>
```

---

## 📄 주요 파일 설명

### **Dockerfile**
```dockerfile
FROM python:3.9-bullseye
RUN pip install --upgrade pip &&     pip install mlflow==2.12.1 scikit-learn
```

### **MLproject**
```yaml
name: iris-classifier-docker

docker_env:
  image: iris-classifier-image
  volumes: ["C:\\dev\\conda\\aiops\\pipelines\\test-train-project:/app"]
  environment: ["MLFLOW_TRACKING_URI"]

entry_points:
  main:
    command: "python /app/train.py"
```

### **train.py**
- 학습 데이터: Iris Dataset
- 모델: RandomForestClassifier
- 아티팩트:
  - `reports/predictions.csv`
  - `model/` (MLflow 모델 포맷)

---

## 📂 아티팩트 저장 위치
- 원격 서버 NAS: `$ROOT_PATH/experiments/<experiment_id>/<run_id>/`
- 예:
```
experiments/1854/d7fc3df276664852be95ee6bc0d14272/reports/predictions.csv
experiments/1854/d7fc3df276664852be95ee6bc0d14272/model/MLmodel
```
- MLflow UI에서도 **Artifacts** 탭을 통해 다운로드 가능

---

## 📜 라이선스
MIT License

## 📜 블로그
겨울나기 바캉스 : https://jarikki.tistory.com/