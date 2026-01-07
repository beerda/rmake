# Check if GNU Make is available via the 'make' command

Function checks if GNU Make is installed and available in the system
PATH via the 'make' command. It also verifies that the version of GNU
Make is at least the minimum required version needed by the package,
which is currently set to 3.82.

## Usage

``` r
hasGnuMake()
```

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
