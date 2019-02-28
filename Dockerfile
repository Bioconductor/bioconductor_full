FROM bioconductor/release_base2:latest

MAINTAINER nitesh.turaga@roswellpark.org

# Update apt-get
RUN apt-get update

# This is to avoid the error
# 'debconf: unable to initialize frontend: Dialog'
ENV DEBIAN_FRONTEND noninteractive

# Additional software needed to get R/Bioc working
RUN apt-get install -y --no-install-recommends \
	apt-utils \
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
	libopenbabel-dev \
	libopenmpi-dev \
	libexempi3 \
	libxt-dev \
	libgdal-dev \
	libjpeg62-turbo-dev \
	libcairo2-dev \
	libtiff5-dev \
	libreadline-dev \
	libgsl0-dev \
	libgsl2 \
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
	libgtkmm-2.4-dev \
	libmpfr-dev \
	libudunits2-dev \
	libmodule-build-perl \
	libapparmor-dev \
	libgeos-dev \
	libprotoc-dev \
	librdf0-dev \
	libmagick++-dev \
	libsasl2-dev \
	libpoppler-cpp-dev \
	libprotobuf-dev \
	libpq-dev \
	libsbml5 \
	libperl-dev \
	## software - perl extentions and modules
	libarchive-extract-perl \
	libfile-copy-recursive-perl \
	libcgi-pm-perl \
	libdbi-perl \
	libdbd-mysql-perl \
	libxml-simple-perl \
	## Databases and other software
	sqlite \
	openmpi-bin \
	mpi-default-bin \
	openmpi-common \
	openmpi-doc \
	tcl8.5-dev \
	## tk-dev (is 8.6-dev), no need of tk8.5-dev
	tk-dev \
	openjdk-8-jdk \
	imagemagick \
	tabix \
	ggobi \
	graphviz \
	protobuf-compiler \
	jags \
	## Additional resources
	xvfb \
	xfonts-100dpi \
	xfonts-75dpi \
	biber

# Install sklearn and pandas on python
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

# Env settings for RStudio
ENV RSTUDIO_PORT 8001

ENV RSTUDIO_HOME /etc/rstudio
ADD rserver.conf $RSTUDIO_HOME/rserver.conf
EXPOSE $RSTUDIO_PORT
