# Check if GNU Make is available via the 'make' command

Check if GNU Make is available via the 'make' command

## Usage

``` r
hasGnuMake(version = "3.82")
```

## Arguments

- version:

  Optional minimum version string to check (the default value, i.e.,
  "3.82" is the minimum required version for rmake package
  functionality)

## Value

Logical value indicating if GNU Make is available

## Author

Michal Burda

## Examples

``` r
if (hasGnuMake()) {
  message("GNU Make is available")
}
#> GNU Make is available
```
