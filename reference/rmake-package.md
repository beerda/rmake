# Makefile generator for R analytical projects

rmake creates and maintains a build process for complex analytic tasks
in R. The package allows easy generation of a Makefile for the (GNU)
'make' tool, which drives the build process by executing build commands
(in parallel) to update results according to given dependencies on
changed data or updated source files.

## Details

Note: The package requires the `R_HOME` environment variable to be
properly set.

## Basic Usage

Suppose you have a file `dataset.csv`. You want to pre-process it and
store the results in `dataset.rds` using the `preprocess.R` R script.
After that, `dataset.rds` is then an input file for `report.Rmd` and
`details.Rmd`, which are R-Markdown scripts that generate `report.pdf`
and `details.pdf`. The whole project can be initialized with rmake as
follows:

1.  Let us assume that you have the rmake package as well as the `make`
    tool properly installed.

2.  Create a new directory (or an R studio project) and copy your
    `dataset.csv` into it.

3.  Load the rmake package and create skeleton files for it:  
    [`library(rmake)`](https://github.com/beerda/rmake)  
    `rmakeSkeleton('.')`  
      
    `Makefile.R` and `Makefile` will be created in the current directory
    (`'.'`).

4.  Create your files `preprocess.R`, `report.Rmd`, and `details.Rmd`.

5.  Edit `Makefile.R` as follows:  
    [`library(rmake)`](https://github.com/beerda/rmake)  
    `job <- list(`  
    ` rRule('dataset.rds', 'preprocess.R', 'dataset.csv'),`  
    ` markdownRule('report.pdf', 'report.Rmd', 'dataset.rds'),`  
    ` markdownRule('details.pdf', 'details.Rmd', 'dataset.rds')`  
    `)`  
    `makefile(job, "Makefile")`  
      
    This will create three build rules: one for processing
    `preprocess.R` and two for executing `report.Rmd` and `details.Rmd`
    to generate the resulting PDF files.

6.  Run `make` or build your project in R Studio (Build/Build all). This
    will automatically re-generate the `Makefile` and execute
    `preprocess.R` and the generation of `report.Rmd` and `details.Rmd`
    according to the changes made to the source files.

## See also

Useful links:

- <https://github.com/beerda/rmake>

- Report bugs at <https://github.com/beerda/rmake/issues>

## Author

**Maintainer**: Michal Burda <michal.burda@osu.cz>
([ORCID](https://orcid.org/0000-0002-4182-4407))
