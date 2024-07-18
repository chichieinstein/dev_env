#!/bin/bash 

create_venv() {
    python3 -m venv mlflow_server
    source mlflow_server/bin/activate 
    pip install mlflow
}

activate_venv() {
    source mlflow_server/bin/activate
}

if [ ! -d "mlflow_server" ]; then 
    echo "Virtual environment 'mlflow_server' does not exist. Creating and installing MLFLow"
    create_venv 
else 
    echo "Virtual environment 'mlflow_server' exists. Activating...."
    activate_venv
fi 

if [ "$#" -ne 2 ]; then 
    echo "Usage: $0 <Project_directory> <absolute_artifact_root_path>"
    exit 1 
fi 

db_directory=$1
artifact_root=$2
artifact_root="file://${artifact_root}"

if [ ! -d "$db_directory" ]; then 
    echo "Error : Directory $db_directory does not exist."
    exit 1
fi 

cd "$db_directory"

backend_store_uri="sqlite:///mlflow.db"

tmux new-session -d -s mlflow_server_session

tmux send-keys -t mlflow_server_session "cd $db_directory && mlflow server --backend-store-uri $backend_store_uri --default-artifact-root $artifact_root --host 127.0.0.1 --port 5000" C-m

echo "MLFlow sever started in a new tmux session 'mlflow_server_session'."
