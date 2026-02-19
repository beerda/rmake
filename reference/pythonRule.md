# Rule for running Python scripts

This rule executes Python scripts to create various file outputs.

## Usage

``` r
pythonRule(
  target,
  script,
  depends = NULL,
  args = NULL,
  python = "python",
  task = "all"
)
```

## Arguments

- target:

  Name of output files to be created

- script:

  Name of the Python script to be executed

- depends:

  A vector of file names that the Python script depends on, or `NULL`.

- args:

  A string with command line arguments for the Python script. This
  string may contain variables `$[DEP1]`, `$[DEP2]`, ..., `$[TARGET1]`,
  `$[TARGET2]`, ... that are replaced with the corresponding file names
  from `depends` and `target`. If `args` is `NULL`, the arguments are
  created from the `depends` and `target` parameters, in that order.

- python:

  The command to execute Python. By default, it is `python`, but it can
  be set to a specific path or to `python3` if needed.

- task:

  A character vector of parent task names. The mechanism of tasks allows
  grouping rules. Anything different from `'all'` will cause the
  creation of a new task depending on the given rule. Executing
  `make taskname` will then force building this rule.

## Value

Instance of S3 class `rmake.rule`

## Details

In detail, this rule executes the following command in a shell:
`python script arguments` where `arguments` are script arguments created
from the `args` parameter. If `args` is `NULL`, the arguments are
created from the `depends` and `target` parameters, in that order. If
`args` is not `NULL`, it must be a string with command line arguments
that may contain variables `$[DEP1]`, `$[DEP2]`, ..., `$[TARGET1]`,
`$[TARGET2]`, ... that are replaced with the corresponding file names
from `depends` and `target`.

Issuing `make clean` from the shell causes removal of all files
specified in the `target` parameter.

## See also

[`rule()`](https://beerda.github.io/rmake/reference/rule.md),
[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md)

## Author

Michal Burda
