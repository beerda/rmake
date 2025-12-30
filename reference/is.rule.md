# Check if the argument is a valid rule object.

Function tests whether `x` is a valid rule object, i.e., whether it is a
list and inherits from the `rmake.rule` S3 class. Instances of `rule`
represent an atomic building unit, i.e., a command that must be
executed, which optionally depends on some files or other rules – see
[`rule()`](https://beerda.github.io/rmake/reference/rule.md) for more
details.

## Usage

``` r
is.rule(x)
```

## Arguments

- x:

  An argument to be tested

## Value

`TRUE` if `x` is a valid rule object and `FALSE` otherwise.

## See also

[`rule()`](https://beerda.github.io/rmake/reference/rule.md),
[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md),
[`rRule()`](https://beerda.github.io/rmake/reference/rRule.md),
[`markdownRule()`](https://beerda.github.io/rmake/reference/markdownRule.md),
[`offlineRule()`](https://beerda.github.io/rmake/reference/offlineRule.md)

## Author

Michal Burda
