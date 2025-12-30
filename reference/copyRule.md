# Rule for copying a file to a new location

This rule copies a file from one location to another. The rule executes
the following command: `$(CP) depends[1] target`

## Usage

``` r
copyRule(target, depends, task = "all")
```

## Arguments

- target:

  Target file name to copy the file to

- depends:

  Name of the file to copy from (only the first element of the vector is
  used)

- task:

  A character vector of parent task names. The mechanism of tasks allows
  grouping rules. Anything different from `'all'` will cause the
  creation of a new task depending on the given rule. Executing
  `make taskname` will then force building this rule.

## Value

Instance of S3 class `rmake.rule`

## See also

[`rule()`](https://beerda.github.io/rmake/reference/rule.md),
[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md)

## Author

Michal Burda
