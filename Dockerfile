FROM node:latest

ARG NMP_VERSION=10.9.1
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
# Bug? Use "JavaScript" to run as "TypeScript" 
#RUN echo "JavaScript" > /webdir/cmd.txt
# Use "0" to run as "JavaScript"
RUN echo "0" > /webdir/cmd.txt 
######################################
RUN npx --yes create-docusaurus@latest /webdir/public classic < /webdir/cmd.txt && \
 cd /webdir/public && \
 yarn install 

EXPOSE 3000
WORKDIR /webdir/public
VOLUME ["/webdir/public/blog","/webdir/public/docs","/webdir/public/src","/webdir/public/static","/webdir/public/docusaurus.config.js"]

# If are some troubles use this file in command line:
#CMD ["tail", "-f", "/run-without-webserver.log"]
CMD ["yarn", "start", "--host", "0.0.0.0"]
