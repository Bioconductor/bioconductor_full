library(BiocManager)
library(httr)
library(yaml)

## Update out of date packages, do for both release and devel
BiocManager::install(valid()$out_of_date, Ncpus=4)

## If devel, check to see if new packages need to be installed.
if (BiocManager:::isDevel()) {
    installed <- rownames(installed.packages())
    biocsoft <- available.packages(repos = BiocManager::repositories()[["BioCsoft"]])

    ## Packages which failed to install on docker image
    to_install <- rownames(biocsoft)[!rownames(biocsoft) %in% installed]
    BiocManager::install(to_install, Ncpus=4)
}


## Install suggests
db <- available.packages(repos = BiocManager::repositories())
pkgs <- tools::package_dependencies(rownames(biocsoft), db=db, which=c("Suggests"))
suggests <- unique(unlist(pkgs, use.names=FALSE))

to_install2 <- suggests[!suggests %in% rownames(installed.packages())]
BiocManager::install(to_install2, destdir="/root/store",Ncpus=4)
