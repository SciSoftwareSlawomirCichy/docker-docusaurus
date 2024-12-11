#################################################
# Generacja projektu strony

export NMP_VERSION=10.9.2

#-------------
# 1. Zbuduj obraz wspierający tworzenie strony
# 1.1 Wydaj polecenie budowania obrazu
docker build --no-cache --build-arg NMP_VERSION=${NMP_VERSION}\
 -f webpage-generator/Dockerfile.generate\
 -t scisoftware/docusaurus:${NMP_VERSION}-dev .

# 1.2 Przygotuj repozytorium nowego projketu strony na Github 
# https://github.com/SciSoftwareSlawomirCichy
# https://github.com/slawascichy
# dla prywatnych repozytoriów przygotuj token uwierzytelniania w pliku gitkey.txt
# zobacz: https://github.com/settings/apps
# Uruchom skrypt:
export NEW_PROJECT_NAME=docusaurus-scisoftware
export VOLUME_HOME=/d/workspace/git/$NEW_PROJECT_NAME
export PROJECT_HOME=/cygdrive${VOLUME_HOME}
./webpage-generator/init_project.sh SciSoftwareSlawomirCichy ${NEW_PROJECT_NAME}
# Skrypt wykonuje następujące kroki: 
## {
#export SECRET_TOKEN=`cat gitkey.txt`
#export GIT_USER=SciSoftwareSlawomirCichy
## np. o nazwie docusaurus-scisoftware
## Skonwertuj ścieżkę do ściezki windows
#export PROJECT_HOME_WIN=`cygpath -w ${PROJECT_HOME}`
## Klonujemy dane projektu z GitHub
#git clone https://${SECRET_TOKEN}@github.com/${GIT_USER}/${NEW_PROJECT_NAME}.git $PROJECT_HOME_WIN
## Przygotuj project Eclipse
#cp eclipse_project_template.xml $PROJECT_HOME/.project 
#sed -i "s|NEW_PROJECT_NAME|${NEW_PROJECT_NAME}|g" $PROJECT_HOME/.project
## }

#-------------
# 2. Uruchom kontener z montowanym zasobem, za pomocą którego ma być 
# wygenerowany projekt docusaurus'a (odpowiednia struktura katalogów)
export CONTAINER_ID=`docker run --name docusaurus-dev --rm --detach \
 -v $VOLUME_HOME:/webdir.service \
 -p 3000:3000 \
 scisoftware/docusaurus:${NMP_VERSION}-dev`
 
#-------------
# 3. Zaloguj się do uruchomionego kontenera i wygeneruj projekt
# 3.1 (opcjonalne) Identyfikator kontenera
#echo $CONTAINER_ID
# 3.3 (opcjonalne) $CONTAINER_ID puste: Aby znaleźć identyfikator kontenera wydaj polecenie:
#docker container ls
# 3.3 Aby zalogować się wydaj polecenie:
docker exec -it $CONTAINER_ID bash
# 3.4 Będąc zalogowanym do kontenera wydaj polecenia: 
> cp -r /webdir.template/* /webdir.service
# ... i gotowe
# ... (opcjonalne) możesz sprawdzić czy wszystko działa:
> npm run build
> npm run serve
# http://localhost:3000/
> [Ctrl+C]
> exit
#-------------
# 3.5 Zatrzymaj kontener
docker stop $CONTAINER_ID

# 4. (opcjonalne) Posprzątaj po tymczasowym kontenerze i jego obrazie...
# 4.1 (opcjonalne) Usuń kontener
# 4.2 (opcjonalne) Usuń obraz z repozytorium Docker scisoftware/docusaurus:${NODE_VERSION}-dev
#################################################

# 5. Kontynuuj prace nad nowym projektem
cd $PROJECT_HOME