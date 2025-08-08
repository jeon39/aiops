import argparse
import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# ===== 파라미터 파싱 =====
parser = argparse.ArgumentParser()
parser.add_argument("--run_name", type=str, default="random-forest-1")
args = parser.parse_args()

# ===== Experiment 설정 =====
mlflow.set_experiment("seongj")  # 없으면 생성, 있으면 연결
mlflow.sklearn.autolog(log_models=False)  # logged-models API 호출 방지

# ===== 데이터 준비 =====
X, y = load_iris(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y)

# ===== 모델 학습 =====
model = RandomForestClassifier(n_estimators=100, max_depth=3)
model.fit(X_train, y_train)

# ===== 평가 =====
preds = model.predict(X_test)
acc = accuracy_score(y_test, preds)
print("accuracy:", acc)

# ===== 추가 로그 =====
mlflow.log_param("run_name", args.run_name)
mlflow.log_param("n_estimators", 100)
mlflow.log_param("max_depth", 3)
mlflow.log_metric("accuracy", acc)
