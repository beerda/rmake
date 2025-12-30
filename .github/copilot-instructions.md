# Copilot Instructions for rmake

## Project Overview

`rmake` is an R package providing a Makefile generator for R analytical projects. It creates and maintains a build process for complex analytic tasks by generating Makefiles that drive the build process through the GNU Make tool.

## Repository Structure

- `R/` - R source code with roxygen2 documentation
- `tests/testthat/` - Unit tests using testthat framework
- `man/` - Generated documentation (auto-generated, do not edit manually)
- `vignettes/` - Package vignettes (both Rnw and Rmd formats)
- `.github/workflows/` - CI/CD workflows for R CMD check and pkgdown

## Development Setup

### Prerequisites
- R >= 3.5.0
- GNU Make tool
- Required R packages: tools, assertthat, rmarkdown, visNetwork, knitr
- Suggested R packages: testthat

### Building and Testing
```r
# Install dependencies
install.packages(c("devtools", "roxygen2", "testthat"))
devtools::install_deps(dependencies = TRUE)

# Build documentation
devtools::document()

# Run tests
devtools::test()

# Run R CMD check
devtools::check()

# Build package
devtools::build()
```

## Coding Standards

### R Code

1. **Documentation**: All exported functions must have complete roxygen2 documentation including:
   - `@title` and description
   - `@param` for all parameters
   - `@return` for return values
   - `@seealso` for references to related functions
   - `@examples` with working examples
   - `@export` for exported functions

2. **Naming Conventions**:
   - Functions: camelCase for user-facing functions (e.g., `rRule()`, `markdownRule()`, `rmakeSkeleton()`)
   - Internal functions: camelCase with leading dot (e.g., `.processRule()`)
   - Variables: camelCase or snake_case consistently within a file

3. **Error Handling**:
   - Use `assertthat` package for input validation
   - Use `stop()` or `warning()` with informative messages
   - Validate rule parameters thoroughly

4. **Style**:
   - Use existing code style in the package
   - Indent with 2 spaces
   - Use `<-` for assignment
   - Follow existing patterns for rule definitions

### Rule System

1. **Rule Structure**:
   - All rules inherit from `rmake.rule` S3 class
   - Rules must have: `target`, `depends`, `build`, `clean`, `task`, `phony` attributes
   - Use `rule()` function as the base constructor

2. **Rule Functions**:
   - Pre-defined rule types: `rRule()`, `markdownRule()`, `knitrRule()`, `copyRule()`, `offlineRule()`, etc.
   - Each rule function should validate inputs and construct appropriate shell commands
   - Rules should support the pipe operator `%>>%`

3. **Makefile Generation**:
   - `makefile()` function generates the Makefile from a list of rules
   - Uses platform-specific commands (Windows vs Unix)
   - Supports parallel execution through Make's `-j` option

### Testing

1. **Test Structure**:
   - Use testthat framework
   - Test files in `tests/testthat/` with `test-*.R` naming
   - Group related tests with `test_that()` blocks

2. **Coverage**:
   - Test all exported functions
   - Test edge cases and error conditions
   - Test rule generation and Makefile creation

3. **Test Naming**:
   - Descriptive test names explaining what is being tested
   - Example: `test_that("rRule creates correct dependencies", { ... })`

## Dependencies

### R Package Dependencies
- Runtime: tools, assertthat, rmarkdown, visNetwork, knitr
- Suggests: testthat

### Adding Dependencies
- Add to appropriate field in DESCRIPTION (Imports, Suggests)
- Use `usethis::use_package()` helper functions
- Document why the dependency is needed
- Minimize new dependencies

## Key Design Patterns

### Pipe Operator (`%>>%`)
- Central to rmake's API
- Allows chaining: `input %>>% rule(script) %>>% output`
- Automatically extracts `depends` and `target` from chain
- Implemented in `R/pipe.R`

### Rule Templates
- `expandTemplate()` function for parameterized rule generation
- Supports template variables like `$[VAR]`
- Useful for creating multiple similar rules

### Parameterized Rules
- Rules can receive `params` list
- Parameters available as `params` global variable in scripts
- Use `getParam()` function to access parameters safely

## Makefile Generation

### Shell Commands
- Platform-specific: Windows uses `del`, Unix uses `rm`
- Use Make variables: `$(R)` for Rscript, `$(RM)` for file removal
- `inShell()` function converts R expressions to shell commands

### Build Process
1. User creates `Makefile.R` with rule definitions
2. `makefile()` generates `Makefile` from rules
3. `make()` executes Make tool
4. Make checks timestamps and executes necessary rules

## Documentation

- Use roxygen2 for all documentation
- Run `devtools::document()` to regenerate man/*.Rd files
- Vignettes in `vignettes/*.Rnw` and `vignettes/*.Rmd`
- Package website built with pkgdown

## Common Tasks

### Adding a New Rule Type
1. Create function in appropriate R/*.R file
2. Add roxygen2 documentation with examples
3. Function should:
   - Accept `target`, `script`, `depends`, `params`, `task` arguments
   - Validate inputs with `assertthat`
   - Construct build/clean commands
   - Call `rule()` with appropriate arguments
4. Export with `@export`
5. Add tests in tests/testthat/
6. Run `devtools::document()`, `devtools::test()`, `devtools::check()`

### Modifying Makefile Generation
1. Edit `R/makefile.R`
2. Update `.makefileRules()` or related functions
3. Test on both Windows and Unix platforms
4. Ensure backward compatibility

### Fixing a Bug
1. Add a failing test that reproduces the bug
2. Fix the code
3. Verify test passes
4. Run full test suite: `devtools::test()`
5. Run R CMD check: `devtools::check()`

## Best Practices

1. **Never edit generated files**: NAMESPACE, man/*.Rd, Makefile
2. **Always run tests**: Use `devtools::test()` frequently
3. **Check the package**: Run `devtools::check()` before committing
4. **Document as you code**: Add roxygen2 comments immediately
5. **Follow existing patterns**: Study similar functions before implementing new features
6. **Platform compatibility**: Test on both Windows and Unix if making platform-specific changes
7. **Maintain backward compatibility**: Changes should not break existing user code

## Vignettes

- Main vignette: `vignettes/rmake-intro.Rnw` (LaTeX/Sweave format)
- Additional Rmd vignettes for specific topics
- Keep both formats: Rnw for JSS-style article, Rmd for pkgdown

## CI/CD Workflows

- **R-CMD-check**: Runs on push/PR to main/master, tests on multiple OS and R versions
- **pkgdown**: Builds and deploys documentation site to GitHub Pages

## Release Process

1. Update version in DESCRIPTION
2. Update NEWS.md
3. Run `devtools::check()`
4. Run rhub checks for CRAN
5. Submit to CRAN with `devtools::release()`

## Getting Help

- Package documentation: `?rmake`
- Vignettes: `browseVignettes("rmake")`
- GitHub issues: https://github.com/beerda/rmake/issues

## Author and Maintainer

Michal Burda  
Institute for Research and Applications of Fuzzy Modeling  
Centre of Excellence IT4Innovations, Division University of Ostrava  
Email: michal.burda@osu.cz
