# Convert R code to a character vector of shell commands evaluating the given R code.

The function takes R commands, deparses them, substitutes existing
variables, and converts everything to character strings, from which a
shell command is created that sends the given R code to the R
interpreter. The function is used internally to print the commands of R
rules into the `Makefile`.

## Usage

``` r
inShell(...)
```

## Arguments

- ...:

  R commands to be converted

## Value

A character vector of shell commands that send the given R code by pipe
to the R interpreter

## See also

[`rRule()`](https://beerda.github.io/rmake/reference/rRule.md),
[`markdownRule()`](https://beerda.github.io/rmake/reference/markdownRule.md)

## Author

Michal Burda

## Examples

``` r
inShell({
  x <- 1
  y <- 2
  print(x+y)
})
#> [1] "$(R) - <<'EOFrmake'" "{"                   "    x <- 1"         
#> [4] "    y <- 2"          "    print(x + y)"    "}"                  
#> [7] "EOFrmake"           
```
