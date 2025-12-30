# Rule for running the make process in a subdirectory

The subdirectory in the `target` argument is assumed to contain its own
`Makefile`. This rule executes `make <targetTask>` in this subdirectory
(where `<targetTask>` is the value of the `targetTask` argument).

## Usage

``` r
subdirRule(target, depends = NULL, task = "all", targetTask = "all")
```

## Arguments

- target:

  Name of the subdirectory

- depends:

  Must be `NULL`

- task:

  A character vector of parent task names. The mechanism of tasks allows
  grouping rules. Anything different from `'all'` will cause the
  creation of a new task depending on the given rule. Executing
  `make taskname` will then force building this rule.

- targetTask:

  What task to execute in the subdirectory.

## Value

An instance of S3 class `rmake.rule`

## See also

[`rule()`](https://beerda.github.io/rmake/reference/rule.md),
[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md)

## Author

Michal Burda
