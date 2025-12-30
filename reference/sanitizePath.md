# Sanitize a file path for the current operating system

This function replaces forward slashes with backslashes on Windows
systems, and leaves the path unchanged on Unix-like systems.

## Usage

``` r
sanitizePath(path)
```

## Arguments

- path:

  A character string representing the file path to be sanitized.

## Value

A sanitized file path suitable for the current operating system.

## Author

Michal Burda
