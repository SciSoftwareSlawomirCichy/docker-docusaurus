#################################################
# Generacja projektu strony 
#
docker build -f webdir/Dockerfile.generate -t scisoftware/docusaurus:10.9.1-g .

docker run --name docusaurus-g --detach \
 -v /d/workspace/git/docker-docusaurus/webdir:/webdir \
 -p 3000:3000 \
 scisoftware/docusaurus:10.9.1-g
 
docker exec -it b184578e6963e191e103a0b09a84a8bd7d9b434c626a6ff5d6d04d7d37d7e203 bash
> echo "0" > /webdir/cmd.txt 
> npx --yes create-docusaurus@latest /webdir/public classic < /webdir/cmd.txt
# ... i gotowe
> exit

cd /cygdrive/d/workspace/git/docker-docusaurus
# Przekopiuj katalogi z /cygdrive/d/workspace/git/docker-docusaurus/webdir/public do katalogu 'webpage' projektu: 
# 1. katalog blog
cp -r webdir/public/blog webpage
# 2. katalog docs
cp -r webdir/public/docs webpage
# 3. katalog src
cp -r webdir/public/src webpage
# 4. katalog static
cp -r static/public/src webpage
# 5. plik docusaurus.config.js
cp -r webdir/public/docusaurus.config.js webpage
#
# Posprzątaj po tymczasowym kontenerze i jego obrazie...
# 1. Usuń kontener
# 2. Usuń obraz z repozytorium Docker scisoftware/docusaurus:10.9.1-g
# 3. usuń wygenerowany katalog webdir/public
rm -rf webdir/public
#################################################
 