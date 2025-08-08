import os
import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import joblib

# 디버깅/검증용: 버전/URI 출력(원하면 넣어두세요)
print("MLflow client version:", mlflow.__version__)
print("Tracking URI:", mlflow.get_tracking_uri())

# 수정
# 데이터/모델
X, y = load_iris(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=42)

# 모델 학습
model = RandomForestClassifier(n_estimators=100, max_depth=3, random_state=42)
model.fit(X_train, y_train)

# 예측 및 평가
preds = model.predict(X_test)
acc = accuracy_score(y_test, preds)
print("accuracy:", acc)

# ==== 수동 로깅 ====

# 파라미터/메트릭
mlflow.log_param("n_estimators", 100)
mlflow.log_param("max_depth", 3)
mlflow.log_metric("accuracy", acc)

# 아티팩트 디렉토리 : 부가 자료 저장 (예시: confusion matrix 이미지, CSV 등)
os.makedirs("artifacts", exist_ok=True)

# 모델 저장 & 로깅 (MLflow 모델 형식)
# 모델을 MLflow 모델 포맷으로 저장/로그
# 서버와 동일 버전이면 404 안 납니다.
# (서버가 구버전인 경우 artifact_path 인자가 정상, 최신에선 name 권장 경고가 보일 수 있음)
mlflow.sklearn.log_model(model, artifact_path="model")

# CSV 예시
import pandas as pd
pd.DataFrame({"y_true": y_test, "y_pred": preds}).to_csv("artifacts/predictions.csv", index=False)


# 아티팩트 로깅
mlflow.log_artifact("artifacts/predictions.csv", artifact_path="reports")
