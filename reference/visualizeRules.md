# Visualize dependencies defined by a rule or a list of rules

Visualize dependencies defined by a rule or a list of rules

## Usage

``` r
visualizeRules(x, legend = TRUE)
```

## Arguments

- x:

  An instance of the S3 `rmake.rule` class or a list of such objects

- legend:

  Whether to draw a legend

## See also

[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md),
[`rule()`](https://beerda.github.io/rmake/reference/rule.md)

## Author

Michal Burda

## Examples

``` r
job <- c('data1.csv', 'data2.csv') %>>%
  rRule('process.R') %>>%
  'data.rds' %>>%
  markdownRule('report.Rmd') %>>%
  'report.pdf'

if (FALSE) { # \dontrun{
visualizeRules(job)
} # }
```
