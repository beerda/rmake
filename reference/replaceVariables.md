# Replace `rmake` variables in a character vector

This function searches for all `rmake` variables in the given vector `x`
and replaces them with their values that are defined in the `vars`
argument. An `rmake` variable is identified by the `$[VARIABLE_NAME]`
string.

## Usage

``` r
replaceVariables(x, vars)
```

## Arguments

- x:

  A character vector where to replace the `rmake` variables

- vars:

  A named character vector with variable definitions (names are variable
  names, values are variable values)

## Value

A character vector with `rmake` variables replaced with their values

## See also

[`expandTemplate()`](https://beerda.github.io/rmake/reference/expandTemplate.md)

## Author

Michal Burda

## Examples

``` r
vars <- c(SIZE='small', METHOD='abc')
replaceVariables('result-$[SIZE]-$[METHOD].csv', vars)   # returns 'result-small-abc.csv'
#> [1] "result-small-abc.csv"
```
