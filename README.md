# docker-docusaurus

I have been looking for a proper documentation server for a very long time and I have to admit that "Docusaurus" is the best solution. It has its flaws, but compared to other products it is really great.
You can find more about the tool at https://docusaurus.io/. 

## About project

In this project I built a Docker image that allows to run the server on address http://localhost:3000/.
![http://localhost:3000/](https://github.com/SciSoftwareSlawomirCichy/docker-docusaurus/blob/main/docs/img/localhost_main_page.png?raw=true)

### Additional volumes declared in image

In image was declared three volumes (see [Dockerfile](Dockerfile)):

| Localization | Description |
| ---- | -------------- |
| /webdir/public/blog | Contains the blog Markdown files. You can delete the directory if you've disabled the blog plugin, or you can change its name after setting the path option. |
| /webdir/public/docs | Contains the Markdown files for the docs. |
| /webdir/public/blog | Non-documentation files like pages or custom React components. |
| /webdir/public/blog | Static directory. Any contents inside here will be copied into the root of the final build directory. |
| /webdir/public/docusaurus.config.js | A config file containing the site configuration. |

For more information about organizing folders in a website project, read the documentation pages of [Project Structure](https://docusaurus.io/docs/installation#project-structure).


### Build image command

> [!TIP]
> You don't need to build an image. You can use a ready-made image stored on Dockerhub: [scisoftware/docusaurus](https://hub.docker.com/repository/docker/scisoftware/docusaurus/general).
> ```
> docker pull scisoftware/docusaurus:10.9.1
> ```


```bash
docker build -f Dockerfile -t scisoftware/docusaurus:10.9.1 .

```

### Run image

For running the container based on the image you can use docker command:

- Linux

> [!TIP]
> Before you run the command set properly environment value `DOCUSAURUS_PROJECT`.

```bash
export DOCUSAURUS_PROJECT=/d/workspace/git/my-webpage
docker run --name my-webpage-sample --rm -it \
 -v $DOCUSAURUS_PROJECT/blog:/webdir/public/blog \
 -v $DOCUSAURUS_PROJECT/docs:/webdir/public/docs \
 -v $DOCUSAURUS_PROJECT/src:/webdir/public/src \
 -v $DOCUSAURUS_PROJECT/static:/webdir/public/static \
 -v $DOCUSAURUS_PROJECT/docusaurus.config.js:/webdir/public/docusaurus.config.js \
 -p 3000:3000 \
 scisoftware/docusaurus:10.9.1
```
- Linux - docker compose

> [!TIP]
> Before you run the command check volumes defined in file [sample-compose.yml](sample-compose.yml).

```bash
docker compose -f sample-compose.yml up
```


- Windows, PowerShell

> [!TIP]
> Before you run the command set properly environment value `DOCUSAURUS_PROJECT`.

```shell
set DOCUSAURUS_PROJECT=/d/workspace/git/my-webpage
docker run --name my-webpage-sample --rm -it `
 -v %DOCUSAURUS_PROJECT%/blog:/webdir/public/blog `
 -v %DOCUSAURUS_PROJECT%/docs:/webdir/public/docs `
 -v %DOCUSAURUS_PROJECT%/src:/webdir/public/src `
 -v %DOCUSAURUS_PROJECT%/static:/webdir/public/static `
 -v %DOCUSAURUS_PROJECT%/docusaurus.config.js:/webdir/public/docusaurus.config.js `
 -p 3000:3000 `
 scisoftware/docusaurus:10.9.1

```


## About [Docusaurus](https://docusaurus.io/)

> Docusaurus is a project for building, deploying, and maintaining open source project websites easily.

***Source: (Githib Docusaurus Project)(https://github.com/facebook/docusaurus)***

### The main differences between Github and Docusaurs

Markdown interpretation differences I found that may affect your decision. 
So far I've only found the following. I'll publish the differences ASAP as I find them.

### Tips

In Github you must to use code for tips:

```md
> [!TIP]
> Use this awesome feature option
```

In Docusaurs you can get the same (or similar) effect by writing:

```md
:::tip My tip

Use this awesome feature option

:::
```

## Sources

- https://docusaurus.io/docs 
- [Create your own Docusaurus image](https://www.avonture.be/blog/docusaurus-docker/)