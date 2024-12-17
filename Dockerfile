FROM node:latest

ARG NMP_VERSION=10.9.2
# Workspace directory name.
ENV WORKSPACE_NAME=public
# Workspace directory is from the Git repository?
ENV WORKSPACE_IS_GIT_REPO=false

RUN npm install -g npm@${NMP_VERSION}

RUN apt update && apt install -y \
 vim \
 sudo
RUN apt clean && \
 rm -fr /var/lib/apt/lists/* && \
 adduser node sudo && \
 echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
 
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
RUN mkdir -p /webdir/service && mkdir -p /webdir/public && mkdir -p /webdir/.git
COPY service/* /webdir/service
COPY templates/* /webdir/template
RUN chown -R node:node /webdir/service && \
 chown -R node:node /webdir/template && \
 chmod u+x /webdir/service/git-pull.sh && \ 
 chmod u+x /webdir/service/startServer.sh && \ 
 chown -R node:node /webdir/public && \
 chown -R node:node /webdir/.git

USER node
EXPOSE 3000
WORKDIR /webdir/public
VOLUME ["/webdir/public", "/webdir/.git"]
ENV PATH="/webdir/service:${PATH}" 

# If are some troubles use this file in command line:
#CMD ["tail", "-f", "/run-without-webserver.log"]
#CMD ["yarn", "start", "--host", "0.0.0.0"]
#CMD ["npm", "run", "serve"]
CMD ["/webdir/service/startServer.sh"]
