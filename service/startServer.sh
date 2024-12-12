#!/bin/bash
set -o pipefail

ulimit -n 8192
export WEB_DIR=/webdir
export WORK_DIR=${WEB_DIR}/public
export BUILD_DIRECTORY=${WORK_DIR}/build
export DOCUSAURUS_CONF_FILE=${WORK_DIR}/docusaurus.config.js
# For resolving fatal error: 
#  detected dubious ownership in repository at '/webdir/public'
git config --global --add safe.directory ${WORK_DIR}
#  Could not resolve host: github.com
git config --unset http.proxy

if [ ! -f "$DOCUSAURUS_CONF_FILE" ]; then
    echo "Create project from template..."
    cp -r /webdir/template/* /webdir/public  
fi

# For resolving fatal error: 
#  cannot chdir to '../../../${WORKSPACE_NAME}': No such file or directory
if [ "${WORKSPACE_NAME}" != "public" ]; then
	WORK_LINK=${WEB_DIR}/${WORKSPACE_NAME}
	if [ ! -L ${WORK_LINK} ] ; then
		ln -s ${WORK_DIR} ${WORK_LINK}
	fi
fi

if [ ! -d "$BUILD_DIRECTORY" ]; then
    echo "Building project..."
    npm run build
fi

echo "**************************"
echo "* Starting Docusaurus Server "
echo "**************************"
npm run serve