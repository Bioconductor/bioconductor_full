FROM bioconductor/release_base2:latest

MAINTAINER nitesh.turaga@roswellpark.org

# This is to avoid the error
# 'debconf: unable to initialize frontend: Dialog'
ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y dselect \
	&& dselect update

RUN apt-get install -y --no-install-recommends \
	## This section installs tools for other software
	pkg-config \
	fortran77-compiler \
	byacc \
	automake \
	curl \
	## This section installs libraries
	libpng-dev \
	libnetcdf-dev \
	libhdf5-serial-dev \
	libfftw3-dev \
	libfftw3-doc \
	libopenbabel-dev \
	libfftw3-3 \
	libfftw3-dev \
	libsbml5 \
	libexempi3 \
	libxt-dev \
	libgdal-dev \
	libjpeg62-turbo-dev \
	libcairo2-dev \
	libtiff5-dev \
	libreadline-dev \
	libgsl2 \
	libgsl0-dev \
	libgtk2.0-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	libgmp3-dev \
	libhdf5-dev \
	libncurses-dev \
	libbz2-dev \
	libxpm-dev \
	liblapack-dev \
	libv8-3.14-dev \
	libperl-dev \
	libmpfr-dev \
	libudunits2-dev \
	libmodule-build-perl \
	libprotobuf-dev \
	libapparmor-dev \
	libgeos-dev \
	libprotoc-dev \
	librdf0-dev \
	libmagick++-dev \
	libsasl2-dev \
	libpoppler-cpp-dev \
	libpq-dev \
	libopenmpi-dev \
	## software - perl extensions and modules
	libarchive-extract-perl \
	libfile-copy-recursive-perl \
	libcgi-pm-perl \
	libdbi-perl \
	libdbd-mysql-perl \
	libgtkmm-2.4-dev \
	libxml-simple-perl \
	## Databases and other software
	sqlite \
	openmpi-bin \
	mpi-default-bin \
	openmpi-common \
	openmpi-doc \
	tcl8.5-dev \
	# tk8.5-dev \
	# tk-dev (is 8.6-dev), no need of tk8.5-dev \
	tk-dev \
	openjdk-8-jdk \
	imagemagick \
	tabix \
	ggobi \
	graphviz \
	protobuf-compiler \
	jags \
	tree \
	## Additional resources
	xvfb \
	xfonts-100dpi \
	xfonts-75dpi \
	biber \
	htop

# Install python packages and deps
RUN pip install sklearn \
	pandas \
	pyyaml \
	mpi4py


# google-cloud-sdk
RUN apt-get install -yq --no-install-recommends \
	apt-utils \
	gnupg \
	lsb-release \
	&& export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
	&& echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
	&& curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
	&& apt-get update \
	&& apt-get install -yq --no-install-recommends \
	google-cloud-sdk \
	&& apt-get -y  install --fix-missing \
	gdb \
	libxml2-dev \
	python-pip \
	libz-dev \
	libmariadb-client-lgpl-dev


## Clean and rm
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

## Likely unneeded bloat?
## apt-get install -y apache2

# Env settings for RStudio
ENV RSTUDIO_PORT 8001

ENV RSTUDIO_HOME /etc/rstudio
ADD rserver.conf $RSTUDIO_HOME/rserver.conf
EXPOSE $RSTUDIO_PORT
