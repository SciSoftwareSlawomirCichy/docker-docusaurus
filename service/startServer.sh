#!/bin/bash
set -o pipefail
ulimit -n 8192

export WEB_DIR=/webdir
export WORK_DIR=${WEB_DIR}/public
export NODE_MODULES_DIRECTORY=${WORK_DIR}/node_modules
export BUILD_DIRECTORY=${WORK_DIR}/build
export DOCUSAURUS_CONF_FILE=${WORK_DIR}/docusaurus.config.js
export NODE_MODULES_PLUGINS=${WORK_DIR}/node_modules_plugins.txt
cd ${WORK_DIR}
sudo chown -R node:node *

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
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>> Workspace is Git repository"
	# Resolving fatal error: 
	#  detected dubious ownership in repository at '/webdir/public'
	git config --global --add safe.directory ${WORK_DIR}
	#  Could not resolve host: github.com
	git config --global --unset http.proxy
    echo ">>> Git configuration updated."
fi

if [ ! -f "$DOCUSAURUS_CONF_FILE" ]; then
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>> Create project from template..."
    cp -r /webdir/template/* /webdir/public  
    echo ">>> Project created."
fi

if [ ! -d "$NODE_MODULES_DIRECTORY" ]; then
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>> Installing node modules..."
	npm add docusaurus
	if [ -f "$NODE_MODULES_PLUGINS" ]; then
    	echo ">>> Installing plugins..."
    	chmod u+x $NODE_MODULES_PLUGINS
		(cd ${WORK_DIR} && exec ${NODE_MODULES_PLUGINS})
	fi
  	echo ">>> Installation done."
	npm fund > /dev/null 2>&1
fi

if [ ! -d "$BUILD_DIRECTORY" ]; then
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>> Building project..."
    npm run build
    echo ">>> Project built."
fi

echo "**************************"
echo "* Starting Docusaurus Server "
echo "**************************"
npm run serve