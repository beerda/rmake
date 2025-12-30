# Variables used within the Makefile generating process

`defaultVars` is a reserved variable, a named vector that defines
Makefile variables, i.e., shell variables that will exist during the
execution of Makefile rules. The content of this variable is written to
the resulting Makefile during the execution of the
[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md)
function.

## Usage

``` r
defaultVars
```

## Format

An object of class `character` of length 4.

## See also

[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md)

## Author

Michal Burda
