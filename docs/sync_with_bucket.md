# Sync Google Instance Package library with Google bucket

## Start a Google VM


First start a google VM (single instance) with about 150 GB space.

Instance details:

	VM name: bioconductor_full_manager

	Machine type: n1-standard-4 (4 vCPUs, 15 GB memory)

	OS: Debian 9

* Install Docker on this machine and other tools needed using the
[script](https://github.com/nturaga/gcloud_docker_install/blob/master/docker_install.sh),
located at https://github.com/nturaga/gcloud_docker_install.

* Make sure access to Google Storage is given under "Cloud API access
  scopes", to "Read/Write" (if not "full").


#### VM setup

1. Install docker on the machine based on Debian 9.

2. Make two folders, under home directory,

		mkdir shared-devel

		mkdir shared-release-3-8

3. Pull docker images from Dockerhub (and update docker images)

		sudo docker pull bioconductor/bioconductor_full:devel

		sudo docker pull bioconductor/bioconductor_full:RELEASE_3_8

4. When starting docker images, make sure to share the correct folder
   with the image,

   For the devel image

		sudo docker run
			-it
			-v <path>/shared-devel:/home/shared-devel
			bioconductor/bioconductor_full:devel
			/bin/bash


   For the release image

		sudo docker run
			-it
			-v <path>/shared-devel:/home/shared-release-3-8
			bioconductor/bioconductor_full:RELEASE_3_8
			/bin/bash


   NOTE: Use `tmux` to start the containers and keep them running as a
   background process. Or just use the `-d` option

		docker run
			-it
			-d
			-v <path>/shared-devel:/home/shared-release-3-8
			--entrypoint /bin/bash
			bioconductor/bioconductor_full:RELEASE_3_8

	To attach to the "RUNNING" docker container to inspect what's going on,

		docker exec -it <container_name> bash


5. Check that both containers are working,

		sudo docker ps

6. To install the **first** time, run the `to_install.R` script.


## Google buckets

There will be two google buckets,

1. bioconductor-full-devel

	Multi-Regional

2. bioconductor-full-release-3-8

	Multi-Regional


Both the buckets will be made publicly "readable"
(https://cloud.google.com/storage/docs/access-control/making-data-public).

Using gsutil:

	gsutil iam ch allUsers:objectViewer gs://bioconductor-full-devel

	gsutil iam ch allUsers:objectViewer gs://bioconductor-full-release-3-8


## Sync packages to buckets from "shared" folder on each docker container


Update packages on the shared volume,

* Find packages out of date

		to_install <- rownames(BiocManager::valid()$out_of_date)

* Install packages out of date

		BiocManager::install(to_install)

* Then, OVERWRITE the packages on the google bucket with the latest
  packages,

  Don't use  `gsutil cp`

		gsutil -m cp -r shared-devel/new_packages gs://bioconductor-full-devel

 Use `rsync` instead of `cp`

		gsutil -m rsync -r shared-devel gs://bioconductor-full-devel

  Use a cron job to set this up.


### script

Put this script in a file `update_packages.R`

```{r}
## Make sure the library path is correct
path <- ""/root/shared/pkglibs"
.libPaths(path)

## BiocManager out of date
to_update <- rownames(BiocManager::valid()$out_of_date)

## Install packages
BiocManager::install(to_update, Ncpus = 4)
```


### Cron tab

TODO: INSTALL cron on google VM

```
crontab -e
```

Add command to run at 9am everyday

```
0 12 * * * R -f update_packages.R
```

start cron service

```
service crond start

service cond restart ## for restarting job
```
