# docker-docusaurus

I have been looking for a proper documentation server for a very long time and I have to admit that "Docusaurus" is the best solution. It has its flaws, but compared to other products it is really great.
You can find more about the tool at https://docusaurus.io/. 

## About project

In this project I built a Docker image that allows to run the server on address http://localhost:3000/.
![http://localhost:3000/](https://github.com/SciSoftwareSlawomirCichy/docker-docusaurus/blob/main/docs/img/localhost_main_page.png?raw=true)

### Volumes declared in image

In image was declared two volumes (see [Dockerfile](Dockerfile)):

| Localization | Description |
| ---- | -------------- |
| /webdir/public | Folder. Contains the Docusaurus project. |
| /webdir/.git | Optional! The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer. The basic Git workflow goes something like this: You modify files in your working tree. |

For more information about organizing folders in a Docusaurus project, read the documentation pages of [Project Structure](https://docusaurus.io/docs/installation#project-structure).


### Build image command

> [!TIP]
> You don't need to build an image. You can use a ready-made image stored on Dockerhub: [scisoftware/docusaurus](https://hub.docker.com/repository/docker/scisoftware/docusaurus/general).
> ```bash
> export NMP_VERSION=10.9.2
> docker pull scisoftware/docusaurus:${NMP_VERSION}
> ```


```bash
export NMP_VERSION=10.9.2
docker build --no-cache --build-arg NMP_VERSION=${NMP_VERSION} \
 -f Dockerfile \
 -t scisoftware/docusaurus:${NMP_VERSION} .

```

### Run image

For running the container based on the image you can use docker command:

- Linux

> [!TIP]
> Before you run the command set properly environment values `NMP_VERSION` and `VOLUME_HOME`.
> ```bash
> export NMP_VERSION=10.9.2
> export VOLUME_HOME=/d/workspace/git/<my-webpage>
> ```

```bash
docker run --name docusaurus --rm -it \
 -v $VOLUME_HOME:/webdir/public \
 -p 3000:3000 \
 scisoftware/docusaurus:${NMP_VERSION}
```
- Linux - docker compose

> [!TIP]
> Before you run the command check volumes defined in file [sample-compose.yml](sample-compose.yml).

```bash
docker compose -f sample-compose.yml up
```


- Windows, PowerShell

> [!TIP]
> Before you run the command set properly environment values `NMP_VERSION` and `VOLUME_HOME`.
> ```bash
> set NMP_VERSION=10.9.2
> set VOLUME_HOME=/d/workspace/git/<my-webpage>
> ```

```shell
docker run --name docusaurus --rm -it `
 -v %VOLUME_HOME%:/webdir/public `
 -p 3000:3000 `
 scisoftware/docusaurus:%NMP_VERSION%
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