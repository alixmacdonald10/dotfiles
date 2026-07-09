#!/usr/bin/env bash

CONTAINER_NAME="$1"
MODEL_NAME="$2"
MODEL="$3"
MODEL_DESC="$4"
MODEL_CTX="$5"
MODELFILE_PATH="/tmp/$MODEL_NAME.Modelfile"

docker exec $CONTAINER_NAME bash -c "printf \"FROM ${MODEL}\nPARAMETER num_ctx ${MODEL_CTX}\n\" > $MODELFILE_PATH"
docker exec $CONTAINER_NAME ollama create "$MODEL_NAME" -f "$MODELFILE_PATH"
