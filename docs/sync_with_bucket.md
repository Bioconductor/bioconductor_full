# Sync Google Instance Package library with Google bucket

## Start a Google VM

First start a google VM (single instance) with about 150 GB space.

Instance details:

	VM name: bioconductor_full_manager

	Machine type: n1-standard-4 (4 vCPUs, 15 GB memory)

	OS: Debian 9

	Boot disk Type: Standard persistant disk

	Boot disk Size: 200 GB

* Make sure access to Google Storage bucket is set to "allUsers" i.e the bucket is public.

  Eg:

		AccessDeniedException: 403 250475993726-compute@developer.gserviceaccount.com does not have storage.objects.get access to bioconductor-full-devel/AUCell/examples/example_aucellResults_class.R.

#### VM setup

1. Install docker on the machine based on Debian 9.

   Install Docker on this machine and other tools needed using the
   [script](https://github.com/nturaga/gcloud_docker_install/blob/master/docker_install.sh)
   ,located at https://github.com/nturaga/gcloud_docker_install.

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
			-v <path>/shared-devel:/usr/local/lib/R/host-site-library
			bioconductor/bioconductor_full:devel
			/bin/bash

   For the release image

		sudo docker run
			-it
			-v <path>/shared-devel:/usr/local/lib/R/host-site-library
			bioconductor/bioconductor_full:RELEASE_3_8
			/bin/bash

   NOTE: Use `tmux` to start the containers and keep them running as a
   background process. Or just use the `-d` option

		sudo docker run -it
			-d
			-v /home/nitesh_turaga_gmail_com/shared-release-3-8:/usr/local/lib/R/host-site-library
			--entrypoint /bin/bash
			bioconductor/bioconductor_full:RELEASE_3_8

		sudo docker run -it
			-d
			-v /home/nitesh_turaga_gmail_com/shared-devel/:/usr/local/lib/R/host-site-library
			--entrypoint /bin/bash
			bioconductor/bioconductor_full:devel

5. Check which containers are running

		CONTAINER ID        IMAGE                                        COMMAND             CREATED             STATUS              PORTS               NAMES
		1a672ced3aac        bioconductor/bioconductor_full:RELEASE_3_8   "/bin/bash"         59 seconds ago      Up 58 seconds       8787/tcp            zealous_hugle
		1e854e70a941        bioconductor/bioconductor_full:devel         "/bin/bash"         4 minutes ago       Up 4 minutes        8787/tcp            suspicious_fermat

6. To attach to the "RUNNING" docker container to inspect what's going on,

		docker exec -it <container_name> bash

	RELEASE

		sudo docker exec -it 1a672ced3aac bash

	DEVEL

		sudo docker exec -it 1e854e70a941 bash

7. To install the **first** time, run the `to_install.R` script.

## Google buckets

No authentication is required for the google buckets. Since it's on
the same "bioconductor-anvil" you can check to see which buckets are
available.

Try `gsutil ls` to see if everything is working as expected.

	$ gsutil ls
	gs://bioconductor-full-devel/
	gs://bioconductor-full-release-3-8/

There will be two google buckets,

1. bioconductor-full-devel : Bucket containing all the pre-compiled packages needed for Bioconductor 3.9 (current devel)

	Multi-Regional

2. bioconductor-full-release-3-8 : Bucket containing all the pre-compiled packages needed for Bioconductor 3.8 (current release)

	Multi-Regional

**NOTE:** Both the buckets will be made publicly "readable"
(https://cloud.google.com/storage/docs/access-control/making-data-public).

Using gsutil:

	gsutil iam ch allUsers:objectViewer gs://bioconductor-full-devel

	gsutil iam ch allUsers:objectViewer gs://bioconductor-full-release-3-8

## Sync packages to buckets from "shared" folder on each docker container

Use `rsync` in gsutil to sync the bucket with the `shared-devel` folder. To make the local directory "data" the same as the contents of gs://mybucket/data:

	 gsutil -m rsync -d -r gs://bioconductor-full-devel shared-devel/

Same with RELEASE_3_8

	 gsutil -m rsync -d -r gs://bioconductor-full-release-3-8 shared-release-3-8/

`gsutil rsync` options:

	-d	Delete extra files under dst_url not found under src_url. By default extra files are not deleted. Note: this option can delete data quickly if you specify the wrong source/destination combination. See the help section above, "BE CAREFUL WHEN USING -d OPTION!".

	-n	Causes rsync to run in "dry run" mode, i.e., just outputting what would be copied or deleted without actually doing any copying/deleting.

	-R, -r	The -R and -r options are synonymous. Causes directories, buckets, and bucket subdirectories to be synchronized recursively. If you neglect to use this option gsutil will make only the top-level directory in the source and destination URLs match, skipping any sub-directories.

	-m option typically will provide a large performance boost if either the source or destination (or both) is a cloud URL. If both source and destination are file URLs the -m option will typically thrash the disk and slow synchronization down.

## Update packages on the shared volume (run as cron tab)

#### Script `update_packages.R`

	library(BiocManager)
	BiocManager::install(valid()$out_of_date, Ncpus=4)

#### For the Devel images

Script located in `cron-scripts/run_devel.sh`

* Packages can be updated on the Docker image using,

		sudo docker run 
			-it 
			-v /home/nitesh_turaga_gmail_com/shared-devel:/usr/local/lib/R/host-site-library 
			bioconductor/bioconductor_full:devel R -f update_packages.R

* Run rsync

		gsutil -m rsync -d -r shared-devel/ gs://bioconductor-full-devel

#### For the RELEASE images

Script located in `cron-scripts/run_release-3-8.sh`

* Packages can be updated on the Docker image using,

		sudo docker run 
			-it 
			-v /home/nitesh_turaga_gmail_com/shared-release-3-8:/usr/local/lib/R/host-site-library 
			bioconductor/bioconductor_full:release-3-8 R -f update_packages.R

* Run rsync

		gsutil -m rsync -d -r shared-release-3-8/ gs://bioconductor-full-release-3-8

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
