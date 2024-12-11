#!/bin/bash
set -o pipefail

ulimit -n 8192
export WORK_DIR=/webdir/public
export BUILD_DIRECTORY=${WORK_DIR}/build
export DOCUSAURUS_CONF_FILE=${WORK_DIR}/docusaurus.config.js

if [ ! -f "$DOCUSAURUS_CONF_FILE" ]; then
    echo "Create project from template..."
    cp -r /webdir/template/* /webdir/public  
fi

if [ ! -d "$BUILD_DIRECTORY" ]; then
    echo "Building project..."
    npm run build
fi

echo "**************************"
echo "* Starting Docusaurus Server "
echo "**************************"
npm run serve