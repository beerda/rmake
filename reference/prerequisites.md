# Return a given set of properties of all rules in a list

`targets()` returns a character vector of all unique values of `target`
properties, `prerequisites()` returns `depends` and `script` properties,
and `tasks()` returns `task` properties of the given
[`rule()`](https://beerda.github.io/rmake/reference/rule.md) or list of
rules.

## Usage

``` r
prerequisites(x)

targets(x)

tasks(x)

terminals(x)
```

## Arguments

- x:

  An instance of the `rmake.rule` class or a list of such instances

## Value

A character vector of unique values of the selected property obtained
from all rules in `x`

## Details

`terminals()` returns only such targets that are not prerequisites to
any other rule.

## See also

[`rule()`](https://beerda.github.io/rmake/reference/rule.md)

## Author

Michal Burda

## Examples

``` r
job <- 'data.csv' %>>%
  rRule('process.R', task='basic') %>>%
  'data.rds' %>>%
  markdownRule('report.Rnw', task='basic') %>>%
  'report.pdf'

prerequisites(job)    # returns c('process.R', data.csv', 'report.Rnw', 'data.rds')
#> [1] "process.R"  "data.csv"   "report.Rnw" "data.rds"  
targets(job)          # returns c('data.rds', 'report.pdf')
#> [1] "data.rds"   "report.pdf"
tasks(job)            # returns 'basic'
#> [1] "basic"
```
