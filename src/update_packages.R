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
