# dev_env
This repo contains Docker files for setting up the environment for development on servers with GPU support. The docker is built using docker-compose. Ensure to submodule update `nvimhelper` to pull latest changes. 

The environment variables need to be specified using a `.env` file. Example is given in the `.env.example` file in the repo. Rename it to `.env` and set the values of the environment variables that you want.

The usage for the `mlflow_server_startup.sh` is 
`./mlflow_server_startup.sh /absolute/path/of/project/ /absolute/path/of/artifact/root`. Ensure that the second argument agrees with the ARTIFACT_ROOT variable in the `.env` file.
