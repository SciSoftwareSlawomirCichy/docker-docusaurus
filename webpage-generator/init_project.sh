#!/bin/bash
########################################################
# Skrypt działa tylko w na windows przy użyciu cygwin
########################################################

########################################################
# Dla prywatnych repozytoriów przygotuj token uwierzytelniania w pliku gitkey.txt
# https://github.com/settings/apps
#
export SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export CURR_DIR=`pwd`
export GIT_KEY_PATH_WIN=`cygpath -w ${CURR_DIR}/gitkey.txt`
echo "Ścieżka klucza: ${GIT_KEY_PATH_WIN}"
export SECRET_TOKEN=`cat ${CURR_DIR}/gitkey.txt`

########################################################
# Przygotuj repozytorium nowego projketu strony na Github 
#  $1=SciSoftwareSlawomirCichy
#  $1=slawascichy
export GIT_USER=$1
# Przykłądowo o nazwie docusaurus-scisoftware
#  $2=docusaurus-scisoftware
export NEW_PROJECT_NAME=$2
export VOLUME_HOME=/d/workspace/git/$NEW_PROJECT_NAME
export PROJECT_HOME=/cygdrive${VOLUME_HOME}
# Skonwertuj ścieżkę do ściezki windows
export PROJECT_HOME_WIN=`cygpath -w ${PROJECT_HOME}`
echo "Ścieżka projketu: ${PROJECT_HOME_WIN}"
# Klonujemy dane projektu z GitHub
git clone https://${SECRET_TOKEN}@github.com/${GIT_USER}/${NEW_PROJECT_NAME}.git $PROJECT_HOME_WIN
# Przygotuj project Eclipse
cp ${SCRIPTPATH}/eclipse_project_template.xml $PROJECT_HOME/.project 
sed -i "s|NEW_PROJECT_NAME|${NEW_PROJECT_NAME}|g" $PROJECT_HOME/.project
