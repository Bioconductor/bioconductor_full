# Bioconductor Devel Docker image

Script used to check if packages are installed,

```
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
```

When we look at the packages which need to be installed,

```
> to_install
 [1] "affycoretools"     "AgiMicroRna"       "ArrayExpressHTS"
 [4] "BiGGR"             "BitSeq"            "bsseq"
 [7] "CAFE"              "Cardinal"          "CATALYST"
[10] "ccfindR"           "ChAMP"             "charm"
[13] "CNVRanger"         "COCOA"             "CytoML"
[16] "derfinderPlot"     "DMRcate"           "dmrseq"
[19] "DSS"               "EasyqpcR"          "EnrichmentBrowser"
[22] "flowQB"            "FourCSeq"          "ggbio"
[25] "GSEABenchmarkeR"   "gwascat"           "intansv"
[28] "kissDE"            "mcaGUI"            "MEAL"
[31] "MinimumDistance"   "MIRA"              "msgbsR"
[34] "Mulcom"            "netReg"            "PathwaySplice"
[37] "PCpheno"           "Pi"                "plateCore"
[40] "ppiStats"          "proFIA"            "puma"
[43] "qrqc"              "R3CPET"            "Rariant"
[46] "Rcwl"              "ReportingTools"    "ReQON"
[49] "RiboProfiling"     "RpsiXML"           "rsbml"
[52] "ScISI"             "scmeth"            "scruff"
[55] "seqbias"           "SLGI"              "SomaticSignatures"
[58] "TCseq"             "VanillaICE"        "vtpnet"
[61] "xps"               "YAPSA"
```

And packages which "FAIL" or error out on the build report, so these
fall into the `##Maintainer issues` sections automatically.

```
> build_rpt_failed_pkgs
 [1] "anamiR"          "ArrayExpressHTS" "bgx"             "BitSeq"
 [5] "charm"           "CytoML"          "dSimer"          "flipflop"
 [9] "flowQ"           "MAIT"            "netReg"          "Prostar"
[13] "qrqc"            "seqbias"
```


## Never install

1. xps

1. Rmpi (this will never build)

    1. ccfindR

## Tough to fix

## Fixed

1. X11 (xvfb) - cairoDevice

1. no DISPLAY variable so Tk is not available - gWidgetstcltk

    1.  mcaGUI

        ```
        ERROR: dependency ‘gWidgetsRGtk2’ is not available for package ‘mcaGUI’
        * removing ‘/root/shared/pkglibs/mcaGUI’
        ```

    1. EasyqpcR (gWidgetsRGtk2 issue)

       ```
       ERROR: dependency ‘gWidgetsRGtk2’ is not available for package ‘EasyqpcR’
       * removing ‘/root/shared/pkglibs/EasyqpcR’
       ```

    1. flowQB
    
       ```
       ERROR: dependency ‘extremevalues’ is not available for package ‘flowQB’
       * removing ‘/root/shared/pkglibs/flowQB’
       ```
       ```
       ** byte-compile and prepare package for lazy loading
       Warning: no DISPLAY variable so Tk is not available
       Error in structure(.External(.C_dotTclObjv, objv), class = "tclObj") :
       [tcl] invalid command name "font".
       
       Error : unable to load R code in package 'gWidgetstcltk'
       ERROR: lazy loading failed for package 'gWidgetstcltk'
       * removing '/root/shared/pkglibs/gWidgetstcltk'
       ERROR: dependency 'gWidgetstcltk' is not available for package 'extremevalues'
       ```

1. rsbml -- check installation of libsbml-dev

    1. BiGGR
    
1. Rcwl - CWL needs to be installed. (this should be easy)

        error: cwltool is not found, Please install cwltool first!
        https://github.com/common-workflow-language/cwltool#install


## Fixable issues / Maintainer issues

1. samtools issues

    1. seqbias
    2. ReQON
    3. ArrayExpressHTS
    4. qrqc

    ```
    pos_table.h:27:26: fatal error: samtools/sam.h: No such file or directory
    #include "samtools/sam.h"
                            ^
    compilation terminated.
    /usr/local/lib/R/etc/Makeconf:166: recipe for target 'pos_table.o' failed
    make: *** [pos_table.o] Error 1
    ERROR: compilation failed for package ‘seqbias’
    * removing ‘/root/shared/pkglibs/seqbias’
    ```

1. bsseq - because `bsseq` fails to install a few packages fail

    ```
    bsseq
    [1] "dmrseq"  "DSS"     "MIRA"    "scmeth"  "DMRcate" "kissDE"  "COCOA"
    [8] "ChAMP"   "MEAL"

    Warning: replacing previous import ‘DelayedArray::rowsum’ by ‘DelayedMatrixStats::rowsum’ when loading ‘bsseq’
    Error: objects ‘rowsum’, ‘colsum’ are not exported by 'namespace:DelayedMatrixStats'
    Execution halted
    ERROR: lazy loading failed for package ‘bsseq’
    removing ‘/root/shared/pkglibs/bsseq’
    ```

1. CATALYST

    ```
    Error : in method for ‘filter’ with signature ‘.data="daFrame"’:  arguments (‘.preserve’) after ‘...’	in the generic must appear in the method, in the same place at the end of the argument list
    Error : unable to load R code in package ‘CATALYST’
    ERROR: lazy loading failed for package ‘CATALYST’
    * removing ‘/root/shared/pkglibs/CATALYST’
    ```

1. VanillaICE

        Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
          The prototype for class “SnpDataFrame” has undefined slot(s): 'isSnp'
        Error: unable to load R code in package ‘VanillaICE’
        Execution halted
        ERROR: lazy loading failed for package ‘VanillaICE’

    1. MinimumDistance

            ERROR: dependency ‘VanillaICE’ is not available for package ‘MinimumDistance’
            removing ‘/root/shared/pkglibs/MinimumDistance’

1. ggbio

    ```
    From .checkSubclasses(): subclass "GeneNameFilter" of class "AnnotationFilter" is not local and is not updated for new inheritance information currently;
    [where=<environment: 0x5650cf8cb038>, where2=<environment: namespace:ggbio>]
    From .checkSubclasses(): subclass "GeneNameFilter" of class "AnnotationFilter" is not local and is not updated for new inheritance information currently;
    [where=<environment: 0x5650cf8cb038>, where2=<environment: namespace:ggbio>]
    Creating a new generic function for 'rescale' in package 'ggbio'
    Creating a new generic function for 'xlim' in package 'ggbio'
    Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
      The prototype for class "GGbio" has undefined slot(s): 'fechable'
    Error: unable to load R code in package 'ggbio'
    Execution halted
    ERROR: lazy loading failed for package 'ggbio'
    ```

    ```
    > failed_deps
    ggbio
     [1] "CAFE"              "derfinderPlot"     "FourCSeq"
     [4] "gwascat"           "intansv"           "msgbsR"
     [7] "Pi"                "R3CPET"            "Rariant"
    [10] "ReportingTools"    "RiboProfiling"     "scruff"
    [13] "SomaticSignatures" "vtpnet"            "affycoretools"
    [16] "EnrichmentBrowser" "YAPSA"             "AgiMicroRna"
    [19] "GSEABenchmarkeR"   "PathwaySplice"
    ```

1. Cardinal

        Error : in method for ‘filter’ with signature ‘.data="ImagingExperiment"’:  arguments (‘.preserve’) after ‘...’ in the generic must appear in the method, in the same place at the end of the argument list
        Error: unable to load R code in package ‘Cardinal’
        Execution halted
        ERROR: lazy loading failed for package ‘Cardinal’

1. charm

        Error: object ‘ebayes’ is not exported by 'namespace:limma'
        Execution halted
        ERROR: lazy loading failed for package ‘charm’
        * removing ‘/root/shared/pkglibs/charm’
1. CytoML

        Error: object ‘transform_gate’ is not exported by 'namespace:ggcyto'
        Execution halted
        ERROR: lazy loading failed for package ‘CytoML’
        * removing ‘/root/shared/pkglibs/CytoML’

1. RpsiXML

    Package has reverse dependencies,

        [1] "ScISI"    "PCpheno"  "ppiStats" "SLGI"

    The package fails because

        No methods found in package ‘Biobase’ for request: ‘listlen’ when loading ‘RpsiXML’
        No methods found in package ‘annotate’ for requests: ‘pubmed’, ‘buildPubMedAbst’ when loading ‘RpsiXML’
        Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
          The prototype for class “psimi25Source” has undefined slot(s): 'uniprotPath'
        Error: unable to load R code in package ‘RpsiXML’
        Execution halted
        ERROR: lazy loading failed for package ‘RpsiXML’
        * removing ‘/root/shared/pkglibs/RpsiXML’

1. TCseq

        Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
          The prototype for class “TCA” has undefined slot(s): ''
        Error: unable to load R code in package ‘TCseq’
        Execution halted
        ERROR: lazy loading failed for package ‘TCseq’
        * removing ‘/root/shared/pkglibs/TCseq’

1. puma

        Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
          The prototype for class “exprReslt” has undefined slot(s): 'exprs', 'se.exprs', 'description', 'notes', 'cdfName', 'nrow', 'ncol'
        Error: unable to load R code in package ‘puma’
        Execution halted
        ERROR: lazy loading failed for package ‘puma’

1. proFIA

        Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
          The prototype for class “proFIAset” has undefined slot(s): 'fClasses'
        Error: unable to load R code in package ‘proFIA’
        Execution halted
        ERROR: lazy loading failed for package ‘proFIA’

1. flowStats

        No methods found in package ‘flowStats’ for request: ‘%on%’ when loading ‘plateCore’
        Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
          The prototype for class “flowPlate” has undefined slot(s): 'plateConfig'
        Error: unable to load R code in package ‘plateCore’
        Execution halted
        ERROR: lazy loading failed for package ‘plateCore’
        * removing ‘/root/shared/pkglibs/plateCore’

1. Mulcom

        Error in reconcilePropertiesAndPrototype(name, slots, prototype, superClasses,  :
          The prototype for class “MULCOM” has undefined slot(s): 'MSE_Correceted'
        Error: unable to load R code in package ‘Mulcom’
        Execution halted
        ERROR: lazy loading failed for package ‘Mulcom’

1. netReg

        configure: R home found in /usr/local/lib/R
        configure: setting CXX to ERROR: no information for variable 'CXX1X' ERROR: no information for variable 'CXX1XSTD'
        checking whether configure should try to set CXXFLAGS... no
        checking whether the C++ compiler works... no
        configure: error: in `/tmp/Rtmp9VdCnP/R.INSTALL2ee43829fe8/netReg':
        configure: error: C++ compiler cannot create executables
        See `config.log' for more details
        ERROR: configuration failed for package ‘netReg’

## Successfully installed

1. CNVRanger
