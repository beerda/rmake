# Prepare an existing project for building with *rmake*.

This function creates a `Makefile.R` with an empty *rmake* project and
generates a basic `Makefile` from it.

## Usage

``` r
rmakeSkeleton(path)
```

## Arguments

- path:

  Path to the target directory where to create files. Use "." for the
  current directory.

## See also

[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md),
[`rule()`](https://beerda.github.io/rmake/reference/rule.md)

## Author

Michal Burda

## Examples

``` r
# creates/overrides Makefile.R and Makefile in a temporary directory
rmakeSkeleton(path=tempdir())
```
