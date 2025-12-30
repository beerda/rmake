# rmake

`rmake` is an R package that creates and maintains a build process for
complex analytic tasks. The package allows easy generation of a Makefile
for the (GNU) ‘make’ tool, which drives the build process by executing
build commands (in parallel) to update results according to given
dependencies on changed data or updated source files.

## Why Use rmake?

R allows the development of **repeatable** statistical analyses, but
when analyses grow in complexity, manual re-execution on any change may
become tedious and error-prone. **Make** is a widely accepted tool for
managing the generation of resulting files from source data and script
files. `rmake` makes it easy to generate Makefiles for R analytical
projects.

## Key Features

- **Integration with Make**: Uses the well-known Make tool for
  dependency management
- **Easy Definitions**: Define file dependencies using R syntax
- **High Flexibility**: Parameterized execution of R scripts and
  programmatically generated dependencies
- **Pipeline Operator**: Simple and short code thanks to the special
  `%>>%` operator
- **Multiple Rule Types**: Support for R scripts, R markdown files, and
  custom rules
- **Extensibility**: Easy to define custom rule types
- **Parallel Execution**: Leverage Make’s parallel processing features
- **Cross-platform**: Support for Unix (Linux), MacOS, MS Windows, and
  Solaris
- **RStudio Compatible**: Works seamlessly with RStudio’s build system

## Installation

To install the stable version of `rmake` from CRAN, type the following
command within the R session:

``` r
install.packages("rmake")
```

Alternatively, you can install the latest development version from
GitHub using the `devtools` package:

``` r
install.packages("devtools")
devtools::install_github("beerda/rmake")
```

## Quick Start

### Setup

The package requires the `R_HOME` environment variable to be properly
set. This variable indicates the directory where R is installed.

**When running from within R or RStudio**, this is automatically set and
no action is needed.

**When running `make` from the command line**, you may need to set it
manually:

#### Finding R_HOME

To find the correct value for your system, run this in R:

``` r
R.home()
```

#### Setting R_HOME

**On Linux/macOS:**

``` bash
export R_HOME=/usr/lib/R  # Use the path from R.home()
```

**On Windows (Command Prompt):**

``` cmd
set R_HOME=C:\Program Files\R\R-4.3.0  # Use the path from R.home()
```

**On Windows (PowerShell):**

``` powershell
$env:R_HOME = "C:\Program Files\R\R-4.3.0"  # Use the path from R.home()
```

For permanent setup, add these to your shell configuration file
(`.bashrc`, `.zshrc`, etc. on Unix-like systems).

For more information on R environment variables, see the [official R
documentation](https://stat.ethz.ch/R-manual/R-devel/library/base/html/EnvVar.html).

### Basic Example

Suppose you have a file `dataset.csv`. You want to pre-process it and
store the results into `dataset.rds` using the `preprocess.R` R script.
After that, `dataset.rds` is then an input file for `report.Rmd` and
`details.Rmd`, which are R-Markdown scripts that generate `report.pdf`
and `details.pdf`. The whole project can be initialized with `rmake` as
follows:

1.  Let us assume that you have the `rmake` package as well as the
    `make` tool properly installed.

2.  Create a new directory (or an R studio project) and copy your
    `dataset.csv` into it.

3.  Load `rmake` and create skeleton files:

    ``` r
    library(rmake)
    rmakeSkeleton('.')
    ```

    `Makefile.R` and `Makefile` will be created.

4.  Create your files `preprocess.R`, `report.Rmd` and `details.Rmd`.

5.  Edit `Makefile.R` as follows:

    ``` r
    library(rmake)
    job <- c('dataset.csv' %>>% rRule('preprocess.R') %>>% 'dataset.rds' %>>% 
               markdownRule('report.Rmd') %>>% 'report.pdf',
             'dataset.rds' %>>% markdownRule('details.Rmd') %>>% 'details.pdf')
    makefile(job, 'Makefile')
    ```

    This will create three build rules: one for processing
    `preprocess.R` and two for executing `report.Rmd` and `details.Rmd`
    to generate the resulting PDF files.

6.  Run [`make()`](https://beerda.github.io/rmake/reference/make.md) or
    build your project in R Studio (Build/Build all). This will
    automatically re-generate `Makefile` and execute `preprocess.R` and
    the generation of `report.Rmd` and `details.Rmd` according to the
    changes made to the source files.

## The Pipe Operator

The `%>>%` pipe operator makes it easy to define chains of dependencies:

``` r
library(rmake)

# Simple chain
job <- "data.csv" %>>% 
  rRule("script.R") %>>% 
  "sums.csv" %>>% 
  markdownRule("analysis.Rmd") %>>% 
  "analysis.pdf"

# Complex dependencies
chain1 <- "data1.csv" %>>% rRule("preprocess1.R") %>>% "intermed1.rds"
chain2 <- "data2.csv" %>>% rRule("preprocess2.R") %>>% "intermed2.rds"
chain3 <- c("intermed1.rds", "intermed2.rds") %>>% 
  rRule("merge.R") %>>% "merged.rds" %>>% 
  markdownRule("report.Rmd") %>>% "report.pdf"

job <- c(chain1, chain2, chain3)
makefile(job, "Makefile")
```

## Visualization

Visualize your build dependencies:

``` r
visualize(job, legend = FALSE)
```

## Parallel Execution

Run multiple targets in parallel using Make’s `-j` option:

``` r
make("-j8")  # Run up to 8 targets simultaneously
```

## Advanced Features

- **Tasks**: Group rules together and execute them selectively
- **Parameterized Execution**: Pass parameters to scripts for flexible
  processing
- **Rule Templates**: Use templates to generate multiple similar rules
  efficiently
- **Custom Rules**: Define your own rule types for specialized tasks

## Getting Help

For more detailed information, see the package vignettes:

- **Introduction to rmake**: Comprehensive guide covering all features
- **Getting Started**: Quick tutorial for beginners

## Contributing

Contributions, suggestions, and bug reports are welcome. Please submit
[issues](https://github.com/beerda/rmake/issues/) on
[GitHub](https://github.com/beerda/rmake/).

## License

GPL (\>= 3.0)

## Author

Michal Burda  
Institute for Research and Applications of Fuzzy Modeling  
Centre of Excellence IT4Innovations, Division University of Ostrava  
Email: <michal.burda@osu.cz>
