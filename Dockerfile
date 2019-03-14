FROM bioconductor/devel_base2:latest

MAINTAINER nitesh.turaga@roswellpark.org

# This is to avoid the error
# 'debconf: unable to initialize frontend: Dialog'
ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils

# Add BiocVersion
RUN R -e "BiocManager::install(version='3.9')"

# This section installs tools for other software
RUN apt-get install -y --no-install-recommends \
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
	tk-dev \
	openjdk-8-jdk \
	imagemagick \
	tabix \
	ggobi \
	graphviz \
	protobuf-compiler \
	jags \
	## Additional resources
	xfonts-100dpi \
	xfonts-75dpi \
	biber

# Install sklearn and pandas on python
RUN pip install sklearn \
	pandas \
	pyyaml \
	mpi4py \
	cwltool

# Install libsbml
RUN cd /tmp \
	&& curl -O https://s3.amazonaws.com/linux-provisioning/libSBML-5.10.2-core-src.tar.gz \
	&& tar zxf libSBML-5.10.2-core-src.tar.gz \
	&& cd libsbml-5.10.2 \
	&& ./configure --enable-layout \
	&& make \
	&& make install

## xvfb start with s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
RUN apt-get update && apt-get install -y xvfb

RUN mkdir -p /etc/services.d/xvfb/
COPY ./deps/xvfb_init /etc/services.d/xvfb/run

## Clean libsbml, and tar.gz files
RUN rm -rf /tmp/libsbml-5.10.2 \
    && rm -rf /tmp/libSBML-5.10.2-core-src.tar.gz \
    && rm -rf /tmp/s6-overlay-amd64.tar.gz

## Clean and rm
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

## Add new user and make 'bioc' sudo,
## Add library to install for 'bioc' user
RUN useradd -ms /bin/bash -d /home/bioc bioc
RUN echo "bioc:bioc" | chpasswd && adduser bioc sudo
USER bioc
RUN mkdir -p /home/bioc/R/library && \
        echo "R_LIBS=~/R/library" | cat > /home/bioc/.Renviron && \
        echo "PATH=${PATH}:${MY_VEP}" | cat >> /home/bioc/.Renviron

USER root

# Init command for s6-overlay
CMD ["/init"]
