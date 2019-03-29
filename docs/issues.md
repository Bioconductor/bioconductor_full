# Issues

There are 16 packages which fail to install,

```
> to_install
 [1] "bgx"         "BiGGR"       "CATALYST"    "ccfindR"     "dSimer"
 [6] "EasyqpcR"    "flipflop"    "flowQB"      "MACPET"      "mcaGUI"
[11] "NADfinder"   "NGScopy"     "rsbml"       "scruff"      "spliceSites"
[16] "xps"
```

## Fixed

1. rsbml - libsbml (dependency)

2. BiGGR

       ERROR: dependency ‘rsbml’ is not available for package ‘BiGGR’
       * removing ‘/root/shared/pkglibs/BiGGR’

3. mcaGUI (gWidgetsRGtk2 issue)

       ERROR: dependency ‘gWidgetsRGtk2’ is not available for package ‘mcaGUI’
       * removing ‘/root/shared/pkglibs/mcaGUI’

4. EasyqpcR (gWidgetsRGtk2 issue)

       ERROR: dependency ‘gWidgetsRGtk2’ is not available for package ‘EasyqpcR’
       * removing ‘/root/shared/pkglibs/EasyqpcR’

5. cairoDevice

6. flowQB

       ERROR: dependency ‘extremevalues’ is not available for package ‘flowQB’
       * removing ‘/root/shared/pkglibs/flowQB’

   When trying to install 'extremevalues', package 'gWidgetstcltk' is
   missing.

       * installing *source* package ‘gWidgetstcltk’ ...
       ** package ‘gWidgetstcltk’ successfully unpacked and MD5 sums checked
       ** R
       ** inst
       ** byte-compile and prepare package for lazy loading
       Warning: no DISPLAY variable so Tk is not available
       Error in structure(.External(.C_dotTclObjv, objv), class = "tclObj") :
       [tcl] invalid command name "font".

       Error : unable to load R code in package ‘gWidgetstcltk’
       ERROR: lazy loading failed for package ‘gWidgetstcltk’
       * removing ‘/root/shared/pkglibs/gWidgetstcltk’
       ERROR: dependency ‘gWidgetstcltk’ is not available for package ‘extremevalues’
       * removing ‘/root/shared/pkglibs/extremevalues’

### Packages which will never install

1. xps

2. ccfindR  (Rmpi)

        ERROR: dependency ‘Rmpi’ is not available for package ‘ccfindR’
        - removing ‘/root/shared/pkglibs/ccfindR’

   Because of this `ccfindR` won't install.

3. dependencies ‘rbamtools’, ‘refGenome’ are not available

        Warning message:
        package ‘rbamtools’ is not available (for R version 3.5.2)

        Warning message:
        package ‘refGenome’ is not available (for R version 3.5.2)

  1. MACPET (not available)

           ERROR: dependency ‘rbamtools’ is not available for package ‘MACPET’
           * removing ‘/root/shared/pkglibs/MACPET’

  1. NADfinder (not available)

           ERROR: dependency ‘rbamtools’ is not available for package ‘NADfinder’
           * removing ‘/root/shared/pkglibs/NADfinder’

  1. NGScopy (not available)

           ERROR: dependency ‘rbamtools’ is not available for package ‘NGScopy’
           * removing ‘/root/shared/pkglibs/NGScopy’

  1. scruff

           ERROR: dependency ‘refGenome’ is not available for package ‘scruff’
           * removing ‘/root/shared/pkglibs/scruff’

  1. spliceSites

           ERROR: dependencies ‘rbamtools’, ‘refGenome’ are not available for package ‘spliceSites’
           * removing ‘/root/shared/pkglibs/spliceSites’

### to fix (maintainer issue / missing dependency)

1. bgx

       Makevars:14: recipe for target 'bgx.o' failed
       make: *** [bgx.o] Error 1
       ERROR: compilation failed for package ‘bgx’
       * removing ‘/root/shared/pkglibs/bgx’

2. CATALYST

       Error : in method for ‘filter’ with signature ‘.data="daFrame"’:  arguments (‘.preserve’) after ‘...’	in the generic must appear in the method, in the same place at the end of the argument list
       Error : unable to load R code in package ‘CATALYST’
       ERROR: lazy loading failed for package ‘CATALYST’
       * removing ‘/root/shared/pkglibs/CATALYST’

3. dSimer

       /usr/local/lib/R/etc/Makeconf:171: recipe for target 'BOG.o' failed
       make: *** [BOG.o] Error 1
       ERROR: compilation failed for package ‘dSimer’
       * removing ‘/root/shared/pkglibs/dSimer’

4. flipflop

       /usr/local/lib/R/etc/Makeconf:171: recipe for target 'align.o' failed
       make: *** [align.o] Error 1
       ERROR: compilation failed for package ‘flipflop’
       * removing ‘/root/shared/pkglibs/flipflop’

## Installation script

The following script installs all packages in the Docker image.

```
test.lib <- "/root/shared-RELEASE_3_8/pkglibs"

if (!dir.exists(test.lib))
       	dir.create(test.lib)

.libPaths(c(test.lib, .libPaths()[length(.libPaths())]))

install.packages("BiocManager", repos = "https://cran.r-project.org")
BiocManager::install(version="3.8", ask=FALSE)

biocsoft <- available.packages(repos = BiocManager::repositories()[["BioCsoft"]])

BiocManager::install(rownames(biocsoft), Ncpus=4, ask=FALSE)
```

After running the script,

```
.libPaths(c("shared/pkglibs/", .libPaths()))

installed <- rownames(installed.packages())
biocsoft <- available.packages(repos = BiocManager::repositories()[["BioCsoft"]])

## Packages which failed to install on docker image
to_install <- rownames(biocsoft)[!rownames(biocsoft) %in% installed]
```
