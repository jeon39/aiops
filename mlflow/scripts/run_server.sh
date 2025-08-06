#!/bin/bash

ROOT_PATH=/mlflow
LOG_PATH=$ROOT_PATH/utils/logs

## 현재 실행되고 있는 프로세스 중 mlflow를 포함하고 있는 프로세스 개수
check=`ps ux | grep mlflow | wc | awk '{print $1}'`

## 프로세스 6개 이상이면, 이미 서버가 실행 중인 것으로 보고 재실행 안함.
if [ $check -gt 6 ]; then
    echo "현재 MLflow 서버가 실행 중입니다."

else
    echo "현재 MLflow 서버가 실행중이 아닙니다."

    ## 오늘 날짜를 0000-00-00 형식으로 불러옴.
    today=$(date "+%Y-%m-%d")

    ## 어제 날짜를 0000-00-00 형식으로 불러옴.
    yesterday=$(date -d "yesterday" "+%Y-%m-%d")

    ## 어제 날짜로 쌓인 로그 tar파일로 저장
    mkdir -p $LOG_PATH/${yesterday}_logs
    mv $LOG_PATH/${yesterday}*.* $LOG_PATH/${yesterday}_logs
    tar -cvf $LOG_PATH/${yesterday}_logs.tar $LOG_PATH/${yesterday}_logs
    rm -rf ${LOG_PATH}/${yesterday}_logs

    echo "\n오늘 날짜 입니다." $today
    
    ## 로그 폴더가 존재하는 경우
    if [ -d $LOG_PATH ]; then
        echo "\n로그를 저장할 폴더가 이미 존재합니다."

        ## 오늘 날짜를 포함하고 있는 로그 파일 개수 카운트
        idx=$(ls -l $LOG_PATH | grep $today | grep ^- | wc -l)

        ## 개수를 세자리 수로 변환
        #? e.g.) 1 -> 001, 2 -> 002, ...
        while [ ${#idx} -ne 3 ]; do
            idx="0"$idx
        done
    else

        ## 로그 폴더가 존재하지 않으면, 생성후 인덱스 값은 000으로 변환
        mkdir -p $LOG_PATH
        echo "로그를 저장할 폴더가 생성되었습니다."
        idx="000"
    fi

    LOG_PATH=${LOG_PATH}/${today}_mlflow_${idx}.log
    echo 이번에 생성할 로그 파일 경로입니다. ${LOG_PATH}

    echo "\nMLFlow 서버를 실행합니다."

    #! sqlite3대신 postgresql에 mlflow 데이터 저장용 코드
    #! postgresql+psycopg2://'db 유저 id':'db 비번'@'db 호스트':'db 포트번호'/'데이터 저장할 db이름'
    nohup mlflow server --backend-store-uri postgresql+psycopg2://genai:'genai1234!%40#$'@10.50.62.159:20159/mlflow \
    --default-artifact-root /mlflow/models --host 0.0.0.0 > $LOG_PATH &

fi
