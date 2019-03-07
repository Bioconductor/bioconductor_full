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
	libopenbabel-dev \
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
	libmpfr-dev \
	libudunits2-dev \
	libmodule-build-perl \
	libprotobuf-dev \
	libapparmor-dev \
	libgeos-dev \
	libsbml5 \
	libprotoc-dev \
	librdf0-dev \
	libmagick++-dev \
	libsasl2-dev \
	libpoppler-cpp-dev \
	libpq-dev \
	libopenmpi-dev \
	libperl-dev \
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
	biber

# Install python packages and deps
RUN pip install sklearn \
	pandas \
	pyyaml \
	mpi4py

## Add a new user after installing software
RUN useradd -ms /bin/bash newuser

## Clean and rm
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

## Enter as newuser
USER newuser
WORKDIR /home/newuser
