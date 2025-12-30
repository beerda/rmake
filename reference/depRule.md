# A rule that defines a dependency between targets without actually providing any execution script.

This rule is useful when you want to specify that a target depends on
another target but you do not want to execute any script to build it.

## Usage

``` r
depRule(target, depends = NULL, task = "all")
```

## Arguments

- target:

  Target file name that depends on `depends`

- depends:

  A character vector of prerequisite file names that `target` depends
  on.

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
