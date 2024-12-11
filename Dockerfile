FROM node:latest

ARG NMP_VERSION=10.9.2
RUN npm install -g npm@${NMP_VERSION}

######################################
# If are some troubles use this file in command line:
# tail -f /run-without-webserver.log
# See: CMD
RUN touch /run-without-webserver.log && chown node:node /run-without-webserver.log
######################################

USER node
WORKDIR /webdir

######################################
# Instalaltion required answer for query "Wich language...?"
# For silent mode use answers in /webdir/cmd.txt
# https://stackoverflow.com/questions/64599477/automate-responses-to-prompts-in-an-npm-npx-command-line-install 
# Comman create docusaurus
# https://docusaurus.io/docs/api/misc/create-docusaurus
######################################
RUN npx create-docusaurus@latest template classic /webdir --javascript --package-manager npm

USER root
RUN mkdir -p /webdir/service && mkdir -p /webdir/public
COPY service/startServer.sh /webdir/service/startServer.sh
RUN chown -R node:node /webdir/service && \
 chmod u+x /webdir/service/startServer.sh && \ 
 chown -R node:node /webdir/public

USER node
EXPOSE 3000
WORKDIR /webdir/public
VOLUME ["/webdir/public"]

# If are some troubles use this file in command line:
#CMD ["tail", "-f", "/run-without-webserver.log"]
#CMD ["yarn", "start", "--host", "0.0.0.0"]
#CMD ["npm", "run", "serve"]
CMD ["/webdir/service/startServer.sh"]
