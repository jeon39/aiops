import os
import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import pandas as pd

# 디버깅 출력
print("MLflow client version:", mlflow.__version__)
print("Tracking URI before set:", mlflow.get_tracking_uri())

# 트래킹 URI 명시 (컨테이너에 -e로 전달됨)
tracking_uri = os.environ.get("MLFLOW_TRACKING_URI")
if tracking_uri:
    mlflow.set_tracking_uri(tracking_uri)
print("Tracking URI after set:", mlflow.get_tracking_uri())

# MLproject가 넘겨준 RUN_ID로 활성화
run_id = os.environ.get("MLFLOW_RUN_ID")
print("Incoming MLFLOW_RUN_ID:", run_id)
mlflow.start_run(run_id=run_id) 

try:
    # 데이터/모델
    X, y = load_iris(return_X_y=True)
    X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=42)

    model = RandomForestClassifier(n_estimators=100, max_depth=3, random_state=42)
    model.fit(X_train, y_train)

    preds = model.predict(X_test)
    acc = accuracy_score(y_test, preds)
    print("accuracy:", acc)

    # 파라미터/메트릭
    mlflow.log_param("n_estimators", 100)
    mlflow.log_param("max_depth", 3)
    mlflow.log_metric("accuracy", acc)

    # 로컬 파일 생성 (컨테이너 내부 작업 디렉토리: /app)
    os.makedirs("artifacts", exist_ok=True)
    pd.DataFrame({"y_true": y_test, "y_pred": preds}).to_csv("artifacts/predictions.csv", index=False)

    # 아티팩트 업로드 (지정한 런에 붙음)
    mlflow.log_artifact("artifacts/predictions.csv", artifact_path="reports")
    mlflow.sklearn.log_model(model, artifact_path="model")

finally:
    # 3) 런 종료 (UI에서 상태가 ‘Running’으로 안 남도록)
    mlflow.end_run()
