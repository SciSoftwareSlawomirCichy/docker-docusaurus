#!/bin/bash
set -o pipefail

ulimit -n 8192
export BUILD_DIRECTORY=/webdir/public/build

if [ ! -d "$BUILD_DIRECTORY" ]; then
    echo "Building project..."
    npm run build
fi

echo "**************************"
echo "* Starting Docusaurus Server "
echo "**************************"
npm run serve