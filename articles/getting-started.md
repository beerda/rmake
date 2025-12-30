# Getting Started with rmake

## Introduction

`rmake` is an R package that creates and maintains a build process for
complex analytic tasks. It allows easy generation of a Makefile for the
(GNU) ‘make’ tool, which drives the build process by executing build
commands (in parallel) to update results according to given dependencies
on changed data or updated source files.

## Why Use rmake?

R allows the development of **repeatable** statistical analyses.
However, when analyses grow in complexity, manual re-execution on any
change may become tedious and error-prone. **Make** is a widely accepted
tool for managing the generation of resulting files from source data and
script files. `rmake` makes it easy to generate Makefiles for R
analytical projects.

## Installation

To install `rmake` from CRAN:

``` r
install.packages("rmake")
```

Alternatively, install the development version from GitHub:

``` r
install.packages("devtools")
devtools::install_github("beerda/rmake")
```

Load the package:

``` r
library(rmake)
```

## Prerequisites

### System Requirements

- **R**: Version 3.5.0 or higher
- **Make**: GNU Make or compatible make tool
  - On Linux/macOS: Usually pre-installed
  - On Windows: Install Rtools (which includes make)

### Environment Variables

The package requires the `R_HOME` environment variable to be properly
set. This is automatically set when running from within R or RStudio. To
run make outside of R:

``` r
# Check environment variables
Sys.getenv("R_HOME")
Sys.getenv("R_ARCH")
```

On Unix-like systems, you can set these in your shell:

``` bash
export R_HOME=/usr/lib/R
export R_ARCH=
```

## Project Initialization

### Creating Skeleton Files

To start a new project with `rmake`:

``` r
library(rmake)
rmakeSkeleton(".")
```

This creates two files: - `Makefile.R` - R script to generate the
Makefile - `Makefile` - The generated Makefile (initially minimal)

The initial `Makefile.R` contains:

``` r
library(rmake)
job <- list()
makefile(job, "Makefile")
```

## Basic Example

Let’s walk through a simple example. Suppose we have: - `data.csv` -
input data file - `script.R` - R script to process the data - Output:
`sums.csv` - computed results

### Step 1: Create the Data File

Create `data.csv`:

    ID,V1,V2
    a,2,8
    b,9,1
    c,3,3

### Step 2: Create the Processing Script

Create `script.R`:

``` r
d <- read.csv("data.csv")
sums <- data.frame(ID = "sum",
                   V1 = sum(d$V1),
                   V2 = sum(d$V2))
write.csv(sums, "sums.csv", row.names = FALSE)
```

### Step 3: Define the Build Rule

Edit `Makefile.R`:

``` r
library(rmake)
job <- list(rRule(target = "sums.csv", 
                  script = "script.R", 
                  depends = "data.csv"))
makefile(job, "Makefile")
```

### Step 4: Run the Build

Execute make:

``` r
make()
```

Make will: 1. Regenerate `Makefile` (if `Makefile.R` changed) 2. Execute
`script.R` to create `sums.csv`

Subsequent calls to
[`make()`](https://beerda.github.io/rmake/reference/make.md) will do
nothing unless files change.

## Using the Pipe Operator

The `%>>%` pipe operator makes rule definitions more readable:

``` r
library(rmake)
job <- "data.csv" %>>% 
  rRule("script.R") %>>% 
  "sums.csv"
makefile(job, "Makefile")
```

This is equivalent to the previous example but more concise.

## Adding a Markdown Report

Let’s extend our example to create a PDF report. Create `analysis.Rmd`:

```` markdown
---
title: "Analysis"
output: pdf_document
---

# Sums of data rows

```{r, echo=FALSE, results='asis'}
sums <- read.csv('sums.csv')
knitr::kable(sums)
```
````

Update `Makefile.R`:

``` r
library(rmake)
job <- list(
  rRule(target = "sums.csv", script = "script.R", depends = "data.csv"),
  markdownRule(target = "analysis.pdf", script = "analysis.Rmd", 
               depends = "sums.csv")
)
makefile(job, "Makefile")
```

Or using pipes:

``` r
library(rmake)
job <- "data.csv" %>>% 
  rRule("script.R") %>>% 
  "sums.csv" %>>% 
  markdownRule("analysis.Rmd") %>>% 
  "analysis.pdf"
makefile(job, "Makefile")
```

Run make again:

``` r
make()
```

## Running Make

### From R

``` r
# Run all tasks
make()

# Run specific task
make("all")

# Clean generated files
make("clean")

# Parallel execution (8 jobs)
make("-j8")
```

### From Command Line

``` bash
make          # Run all tasks
make clean    # Clean generated files
make -j8      # Parallel execution
```

### From RStudio

1.  Go to **Build** \> **Configure Build Tools**
2.  Set **Project build tools** to **Makefile**
3.  Use **Build All** button

## Visualizing Dependencies

Visualize the dependency graph:

``` r
visualize(job, legend = FALSE)
```

This creates an interactive graph showing: - **Squares**: Data files -
**Diamonds**: Script files  
- **Ovals**: Rules - **Arrows**: Dependencies

## Multiple Dependencies

Handle complex dependencies:

``` r
chain1 <- "data1.csv" %>>% rRule("preprocess1.R") %>>% "intermed1.rds"
chain2 <- "data2.csv" %>>% rRule("preprocess2.R") %>>% "intermed2.rds"
chain3 <- c("intermed1.rds", "intermed2.rds") %>>% 
  rRule("merge.R") %>>% "merged.rds" %>>% 
  markdownRule("report.Rmd") %>>% "report.pdf"

job <- c(chain1, chain2, chain3)
```

## Rule Types

`rmake` provides several pre-defined rule types:

- **[`rRule()`](https://beerda.github.io/rmake/reference/rRule.md)**:
  Execute R scripts
- **[`markdownRule()`](https://beerda.github.io/rmake/reference/markdownRule.md)**:
  Render R Markdown documents
- **[`knitrRule()`](https://beerda.github.io/rmake/reference/knitrRule.md)**:
  Process knitr documents
- **[`copyRule()`](https://beerda.github.io/rmake/reference/copyRule.md)**:
  Copy files
- **[`offlineRule()`](https://beerda.github.io/rmake/reference/offlineRule.md)**:
  Manual tasks with reminders

## Next Steps

For more advanced features, see the comprehensive introduction vignette:

``` r
vignette("rmake-introduction", package = "rmake")
```

Topics covered in the full vignette: - Tasks and task management -
Parameterized rule execution - Rule templates - Custom rule types -
Advanced dependency patterns

## Summary

Key takeaways: 1. Use
[`rmakeSkeleton()`](https://beerda.github.io/rmake/reference/rmakeSkeleton.md)
to initialize projects 2. Define rules in `Makefile.R` 3. Use `%>>%` for
readable rule chains 4. Run
[`make()`](https://beerda.github.io/rmake/reference/make.md) to execute
the build process 5. Use `visualize()` to understand dependencies

## Resources

- Package documentation:
  [`?rmake`](https://beerda.github.io/rmake/reference/rmake-package.md)
- GitHub: <https://github.com/beerda/rmake>
- Issues: <https://github.com/beerda/rmake/issues>
