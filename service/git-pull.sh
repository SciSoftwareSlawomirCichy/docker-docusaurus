#!/bin/bash

ulimit -n 8192
export WEB_DIR=/webdir
export WORK_DIR=${WEB_DIR}/${WORKSPACE_NAME}
cd ${WORK_DIR}

git config --unset http.proxy
git stash
git pull

exit 0