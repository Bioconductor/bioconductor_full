## Set libs
test.lib <- "/root/shared/pkglibs"
.libPaths(c(test.lib, .libPaths()[length(.libPaths())]))

library(dplyr)
library(BiocPkgTools)

## Get installed packages
installed <- rownames(installed.packages())
biocsoft <- available.packages(repos = BiocManager::repositories()[["BioCsoft"]])

## Packages which failed to install on docker image
to_install <- rownames(biocsoft)[!rownames(biocsoft) %in% installed]


## Packages which are failing on the build report
rpt = biocBuildReport()
build_rpt_failed_pkgs = rpt %>%
	filter(node == "malbec2",
	       stage == "install",
	       result == "ERROR") %>%
	pull(pkg)

## Bad packages which don't work
pkg <- c("ggbio","rsbml", "VanillaICE", "seqbias", "BitSeq", "Rmpi","ScISI","RpsiXML", "bsseq" )
deps <- tools::package_dependencies(to_install,
				    db = biocsoft, reverse = TRUE, recursive=TRUE)
to_install <- setdiff(
		to_install,
		c(pkg,
		  tools::package_dependencies(pkg,
					      db =biocsoft,
					      reverse=TRUE,
					      recursive=TRUE)[[1]] ))

## remove failed packages in build report, and
## some other packages which cannot be installed
to_install <- setdiff(to_install, build_rpt_failed_pkgs)

deps <- tools::package_dependencies(to_install,
				    db = biocsoft, reverse = TRUE, recursive=TRUE)
