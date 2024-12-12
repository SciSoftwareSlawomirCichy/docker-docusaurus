#!/bin/bash
set -o pipefail

ulimit -n 8192
export WEB_DIR=/webdir
export WORK_DIR=${WEB_DIR}/public
export BUILD_DIRECTORY=${WORK_DIR}/build
export DOCUSAURUS_CONF_FILE=${WORK_DIR}/docusaurus.config.js
cd ${WORK_DIR}

# Resolving fatal error: 
#  cannot chdir to '../../../${WORKSPACE_NAME}': No such file or directory
# We always perform this step even though the problem only occurred when 
# building the project from the Git repository. 
if [ "${WORKSPACE_NAME}" != "public" ]; then
	WORK_LINK=${WEB_DIR}/${WORKSPACE_NAME}
	if [ ! -L ${WORK_LINK} ] ; then
		ln -s ${WORK_DIR} ${WORK_LINK}
	fi
fi

# Workspace directory is from the Git repository.
if [ "${WORKSPACE_IS_GIT_REPO}" == "true" ]; then
    echo "Workspace is Git repository"
	# Resolving fatal error: 
	#  detected dubious ownership in repository at '/webdir/public'
	git config --global --add safe.directory ${WORK_DIR}
	#  Could not resolve host: github.com
	git config --global --unset http.proxy
fi

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