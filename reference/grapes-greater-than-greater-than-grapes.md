# A pipe operator for rmake rules

This pipe operator simplifies the definition of multiple rmake rules
that constitute a chain, that is, if a first rule depends on the results
of a second rule, which depends on the results of a third rule and so
on.

## Usage

``` r
lhs %>>% rhs
```

## Arguments

- lhs:

  A dependency file name or a call to a function that creates a
  `rmake.rule`.

- rhs:

  A target file or a call to a function that creates a `rmake.rule`.

## Value

A list of instances of the `rmake.rule` class.

## Details

The format of proper usage is as follows:
`'inFile' %>>% rule() %>>% 'outFile'`, which is equivalent to the call
`rule(depends='inFile', target='outFile')`. `rule` must be a function
that accepts the named parameters `depends` and `target` and creates the
`rmake.rule` object (see
[`rule()`](https://beerda.github.io/rmake/reference/rule.md),
[`rRule()`](https://beerda.github.io/rmake/reference/rRule.md),
[`markdownRule()`](https://beerda.github.io/rmake/reference/markdownRule.md),
etc.). `inFile` and `outFile` are file names.

Multiple rules may be pipe-lined as follows:
`'inFile' %>>% rRule('script1.R') %>>% 'medFile' %>>% rRule('script2.R') %>>% 'outFile'`,
which is equivalent to a job of two rules created with:
`rRule(script='script1.R', depends='inFile', target='medFile')` and
`rRule(script='script2.R', depends='medFile', target='outFile')`.

## See also

[`rule()`](https://beerda.github.io/rmake/reference/rule.md),
[`makefile()`](https://beerda.github.io/rmake/reference/makefile.md)

## Author

Michal Burda (`%>>%` operator is derived from the code of the `magrittr`
package by Stefan Milton Bache and Hadley Wickham)

## Examples

``` r
job1 <- 'data.csv' %>>%
  rRule('preprocess.R') %>>%
  'data.rds' %>>%
  markdownRule('report.rnw') %>>%
  'report.pdf'

# is equivalent to

job2 <- list(rRule(target='data.rds', script='preprocess.R', depends='data.csv'),
             markdownRule(target='report.pdf', script='report.rnw', depends='data.rds'))
```
