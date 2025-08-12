import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

#mlflow.sklearn.autolog(log_models=False)  # 404 경고 방지

X, y = load_iris(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y)

model = RandomForestClassifier(n_estimators=100, max_depth=3)
model.fit(X_train, y_train)

preds = model.predict(X_test)
acc = accuracy_score(y_test, preds)
print("accuracy:", acc)

mlflow.log_param("n_estimators", 100)
mlflow.log_param("max_depth", 3)
mlflow.log_metric("accuracy", acc)
