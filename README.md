# Bioconductor RELEASE_3_9 Docker image

Bioconductor Docker image with full set of system dependencies so that
all Bioconductor packages can be installed.

The Docker images have R and Bioconductor with different versions
under each "branch" in git.

**NOTE**: Docker image for bioconductor_full:devel is in the `master`
branch, and all the release branches will be under the branch
`RELEASE_X_Y`.

Important Links:

[Docker hub link for bioconductor_full](https://cloud.docker.com/u/bioconductor/repository/registry-1.docker.io/bioconductor/bioconductor_full)

[Github development link for bioconductor_full](https://github.com/Bioconductor/bioconductor_full)

## Advantages of the `bioconductor_full` docker image

1. The bioconductor_full docker images can be used instead of installing
complex dependencies needed for Bioconductor packages. The image comes
with most of the dependencies installed.

1. Quick start up to start your analysis with all the Bioconductor
   packages if needed.

1. The image will be regularly updated to reflect the build system on
   Bioconductor. This is a very useful resource for maintainers who
   are actively developing their package to see if it works in tandem
   with the bioconductor ecosystem. It provides a local testing outlet
   for maintainers and developers.

## Installation and quick start

This document assumes you have [docker](https://www.docker.com/)
installed. Please check
[installation](https://www.docker.com/products/docker-desktop) if you
have more questions regarding this.

### Quick start

* Start docker on your machine.

* On the command line, "pull" the bioconductor_full docker image with
  the correct tag. These images are hosted on docker hub under the
  Bioconductor organization page, located at this [link](https://cloud.docker.com/u/bioconductor/repository/registry-1.docker.io/bioconductor/bioconductor_full).

		docker pull bioconductor/bioconductor_full:devel

	or

		docker pull bioconductor/bioconductor_full:RELEASE_X_Y

* Once the image is available on your local machine, you can check to
  see if they are available.

		docker images

* To start using these images with RStudio, this will start the image
  under the 'rstudio' user

		docker run
			-p 8787:8787
			-v <local/path/host-site-repositories>:/
			bioconductor/bioconductor_full:RELEASE_3_9

* To start the image interactively using the `bioc` user

		docker run
			-it
			--user bioc
			-v <local/path/R-libraries>:/usr/local/lib/R/host-site-library
			bioconductor/bioconductor_full:RELEASE_3_9

	NOTE: The path `/usr/local/lib/R/host-site-library` is mapped to
	`.libPaths()` in R. So, when R is started, all the libraries in
	the directory, `/usr/local/lib/R/host-site-library` is available
	to R. It is stored on your machine mounted from the volume you
	fill in place of `<local/path/R-libraries>`.

	These libraries will only work if they are pre-compiled with the
	same version of R that is in the docker image. To explain further,
	you would need the packages built with Bioconductor version '3.10'
	to work with R-3.6. Similarly, you'd need Bioconductor version
	'3.9' to work with R-3.6.z.

* To start the docker image in deamon mode, i.e, have the container
  running in the background use the `-d` option.

		sudo docker run -it
			-d
			-v /host-site-libraries:/usr/local/lib/R/host-site-libraries
			--entrypoint /bin/bash
			bioconductor/bioconductor_full:RELEASE_3_9

	This will start the container in the background and keep it
	running. You may check the running processes using `docker ps`,
	and copy the container id.

		docker ps

	To attach to a container which is running in the background

		docker exec -it <container_id> bash

	NOTE: You can replace `bash` with R to start R directly in the
	container.

		docker exec -it <container_id> R

## Issues in the devel image

### Packages which will never install

1. xps

1. Rmpi

1. ccfindR

For more information on the issues for this image, please check
`issues.md`
