# Expand template rules into a list of rules by replacing `rmake` variables with their values

The functionality of `expandTemplate()` differs according to the type of
the first argument. If the first argument is a template job (i.e., a
list of template rules) or a template rule, then a job is created from
templates by replacing `rmake` variables in templates with the values of
these variables, as specified in the second argument. An `rmake`
variable is a part of a string in the format `$[VARIABLE_NAME]`.

## Usage

``` r
expandTemplate(template, vars)
```

## Arguments

- template:

  An instance of the S3 `rmake.rule` class, or a list of such objects,
  or a character vector.

- vars:

  A named character vector, matrix, or data frame with variable
  definitions. For character vector, names are variable names, values
  are variable values. For matrix or data frame, colnames are variable
  names and column values are variable values.

## Value

If `template` is an instance of the S3 `rmake.rule` class, or a list of
such objects, a list of rules created from `template` by replacing
`rmake` variables is returned. If `template` is a character vector then
a character vector with all variants of `rmake` values is returned.

## Details

If `vars` is a character vector, then all variables in `vars` are
replaced in `template` so that the result will contain
`length(template)` rules. If `vars` is a data frame or a character
matrix, then the replacement of variables is performed row-wise. That
is, a new sequence of rules is created from `template` for each row of
variables in `vars`, so that the result will contain
`nrow(vars) * length(template)` rules.

If the first argument of `expandTemplate()` is a character vector, then
the result is a character vector created by row-wise replacements of
`rmake` variables, similarly to the case of template jobs. See examples.

## See also

[`replaceVariables()`](https://beerda.github.io/rmake/reference/replaceVariables.md),
[`rule()`](https://beerda.github.io/rmake/reference/rule.md)

## Author

Michal Burda

## Examples

``` r
# Examples with template jobs and rules:

tmpl <- rRule('data-$[VERSION].csv', 'process-$[TYPE].R', 'output-$[VERSION]-$[TYPE].csv')

job <- expandTemplate(tmpl, c(VERSION='small', TYPE='a'))
# is equivalent to
job <- list(rRule('data-small.csv', 'process-a.R', 'output-small-a.csv'))

job <- expandTemplate(tmpl, expand.grid(VERSION=c('small', 'big'), TYPE=c('a', 'b', 'c')))
# is equivalent to
job <- list(rRule('data-small.csv', 'process-a.R', 'output-small-a.csv'),
            rRule('data-big.csv', 'process-a.R', 'output-big-a.csv'),
            rRule('data-small.csv', 'process-b.R', 'output-small-b.csv'),
            rRule('data-big.csv', 'process-b.R', 'output-big-b.csv'),
            rRule('data-small.csv', 'process-c.R', 'output-small-c.csv'),
            rRule('data-big.csv', 'process-c.R', 'output-big-c.csv'))


# Examples with template character vectors:
expandTemplate('data-$[MAJOR].$[MINOR].csv',
               c(MAJOR=3, MINOR=1))
#> [1] "data-3.1.csv"
# returns: c('data-3.1.csv')

expandTemplate('data-$[MAJOR].$[MINOR].csv',
               expand.grid(MAJOR=c(3:4), MINOR=c(0:2)))
#> Warning: Converting all values in `vars` to character vectors.
#> [1] "data-3.0.csv" "data-4.0.csv" "data-3.1.csv" "data-4.1.csv" "data-3.2.csv"
#> [6] "data-4.2.csv"
# returns: c('data-3.0.csv', 'data-4.0.csv',
#            'data-3.1.csv', 'data-4.1.csv',
#            'data-3.2.csv', 'data-4.2.csv')
```
