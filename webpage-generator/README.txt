#################################################
# Generacja projektu strony

#-------------
# 1. Zbuduj obraz wspierający tworzenie strony
# 1.1 Ustaw bazowy katalog projektu pobranego z GIT, np.:
export VOLUME_HOME=/d/workspace/git/docker-docusaurus
export PROJECT_HOME=/cygdrive${VOLUME_HOME}
# 1.2 Sprawdź czy znajdujesz się w odpowiednim katalogu
cd $PROJECT_HOME
# 1.3 Wydaj polecenie budowania obrazu
docker build --no-cache \
 -f webpage-generator/Dockerfile.generate \ 
 -t scisoftware/docusaurus:10.9.1-dev .

#-------------
# 2. Uruchom kontener z montowanym zasobem, za pomocą którego ma być 
# wygenerowany projekt docusaurus'a (odpowiednia struktura katalogów)
export CONTAINER_ID=`docker run --name docusaurus-dev --rm --detach \
 -v $VOLUME_HOME/webpage-generator:/webdir \
 -p 3000:3000 \
 scisoftware/docusaurus:10.9.1-dev`
 
#-------------
# 3. Zaloguj się do uruchomionego kontenera i wygeneruj projekt
# 3.1 (opcjonalne) Identyfikator kontenera
echo $CONTAINER_ID
# 3.3 (opcjonalne) $CONTAINER_ID puste: Aby znaleźć identyfikator kontenera wydaj polecenie:
docker container ls
# 3.3 Aby zalogować się wydaj polecenie:
docker exec -it $CONTAINER_ID bash
# 3.4 Będąc zalogowanym do kontenera wydaj polecenia: 
> echo "0" > /webdir/cmd.txt && npx --yes create-docusaurus@latest /webdir/public classic  < /webdir/cmd.txt
# ... i gotowe
> exit
#-------------
# 3.5 Zatrzymaj kontener
docker rm -f $CONTAINER_ID
# 3.6 Sprawdź czy znajdujesz się w odpowiednim katalogu
cd $PROJECT_HOME

#-------------
# 4. Przekopiuj katalogi z lokalizacji podłączonego wolumenu 
# z /cygdrive/d/workspace/git/docker-docusaurus/webpage-generator/public do katalogu 'webpage' projektu: 
cp -r webpage-generator/public/* webpage

# 5. Posprzątaj po tymczasowym kontenerze i jego obrazie...
# 5.1 Usuń kontener
# 5.2 Usuń obraz z repozytorium Docker scisoftware/docusaurus:10.9.1-dev
# 5.3 usuń wygenerowany katalog webdir/public
rm -rf webpage-generator/public
#################################################
 