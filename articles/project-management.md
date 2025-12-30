# rmake Project Management

## Introduction

This vignette covers the essential aspects of managing an `rmake`
project, including project initialization, running the build process,
cleaning up generated files, and executing builds in parallel.

For an introduction to rmake concepts and basic usage, see the [Getting
Started with
rmake](https://beerda.github.io/rmake/articles/getting-started.md)
vignette. For detailed information on rule types, see the [Build
Rules](https://beerda.github.io/rmake/articles/build-rules.md) vignette.
For advanced features like tasks and templates, see the [Tasks and
Templates](https://beerda.github.io/rmake/articles/tasks-and-templates.md)
vignette.

## Project Initialization

To start maintaining an R project with `rmake`, create a script
`Makefile.R` that generates the `Makefile`. Start from a skeleton:

``` r
library(rmake)
rmakeSkeleton(".")
```

This creates two files: - `Makefile.R` - R script with rule
definitions - `Makefile` - Generated Makefile

Initial `Makefile.R`:

``` r
library(rmake)
job <- list()
makefile(job, "Makefile")
```

## Running the Build Process

Execute make from within R:

``` r
make()
```

Or from shell:

``` bash
make
```

In RStudio: 1. **Build** \> **Configure Build Tools** 2. Set **Project
build tools** to **Makefile** 3. Use **Build All** command

## Cleaning Up

Delete all generated files:

``` r
make("clean")
```

Each rule automatically adds commands to delete its target files. The
`Makefile` itself is never deleted.

## Parallel Execution

GNU Make supports parallel execution with the `-j` option:

``` r
make("-j8")  # Run up to 8 tasks simultaneously
```

From shell:

``` bash
make -j8
```

## Summary

This vignette covered the basics of managing an `rmake` project:

- **Project Initialization**: Use
  [`rmakeSkeleton()`](https://beerda.github.io/rmake/reference/rmakeSkeleton.md)
  to create initial project files
- **Running Builds**: Execute
  [`make()`](https://beerda.github.io/rmake/reference/make.md) from R or
  `make` from shell, or use RStudio’s build tools
- **Cleaning Up**: Use `make("clean")` to remove generated files
- **Parallel Execution**: Use `make("-j8")` to run multiple targets
  simultaneously

## See Also

For more information on related topics, see these vignettes:

- [Getting Started with
  rmake](https://beerda.github.io/rmake/articles/getting-started.md):
  Introduction, basic usage, and the pipe operator
- [Build Rules](https://beerda.github.io/rmake/articles/build-rules.md):
  Comprehensive reference for all rule types
- [Tasks and
  Templates](https://beerda.github.io/rmake/articles/tasks-and-templates.md):
  Advanced features including tasks, parameterized execution, and rule
  templates
