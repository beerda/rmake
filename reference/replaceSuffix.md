# Replace the suffix of a given file name with a new extension (suffix)

This helper function takes a file name `fileName`, removes its extension
(suffix), and adds a new extension `newSuffix`.

## Usage

``` r
replaceSuffix(fileName, newSuffix)
```

## Arguments

- fileName:

  A character vector with original filenames

- newSuffix:

  A new extension to replace old extensions in file names `fileName`

## Value

A character vector with new file names with old extensions replaced with
`newSuffix`

## Author

Michal Burda

## Examples

``` r
replaceSuffix('filename.Rmd', '.pdf')          # 'filename.pdf'
#> [1] "filename.pdf"
replaceSuffix(c('a.x', 'b.y', 'c.z'), '.csv')  # 'a.csv', 'b.csv', 'c.csv'
#> [1] "a.csv" "b.csv" "c.csv"
```
