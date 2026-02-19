# Package index

## Build Process Creation and Management

Core functions to define and execute the build process.

- [`rmakeSkeleton()`](https://beerda.github.io/rmake/reference/rmakeSkeleton.md)
  :

  Prepare an existing project for building with *rmake*.

- [`makefile()`](https://beerda.github.io/rmake/reference/makefile.md) :

  Generate Makefile from a given list of rules (`job`).

- [`make()`](https://beerda.github.io/rmake/reference/make.md) :

  Run `make` in the system

- [`visualizeRules()`](https://beerda.github.io/rmake/reference/visualizeRules.md)
  : Visualize dependencies defined by a rule or a list of rules

- [`defaultVars`](https://beerda.github.io/rmake/reference/defaultVars.md)
  : Variables used within the Makefile generating process

## Rule Types

Functions for defining different types of build rules.

- [`rule()`](https://beerda.github.io/rmake/reference/rule.md) :

  General creator of an instance of the S3 `rmake.rule` class

- [`rRule()`](https://beerda.github.io/rmake/reference/rRule.md) : Rule
  for running R scripts

- [`markdownRule()`](https://beerda.github.io/rmake/reference/markdownRule.md)
  : Rule for building text documents from Markdown files

- [`knitrRule()`](https://beerda.github.io/rmake/reference/knitrRule.md)
  : Rule for building text documents using the knitr package

- [`copyRule()`](https://beerda.github.io/rmake/reference/copyRule.md) :
  Rule for copying a file to a new location

- [`offlineRule()`](https://beerda.github.io/rmake/reference/offlineRule.md)
  : Rule for requesting manual user action

- [`depRule()`](https://beerda.github.io/rmake/reference/depRule.md) : A
  rule that defines a dependency between targets without actually
  providing any execution script.

- [`subdirRule()`](https://beerda.github.io/rmake/reference/subdirRule.md)
  : Rule for running the make process in a subdirectory

- [`pythonRule()`](https://beerda.github.io/rmake/reference/pythonRule.md)
  : Rule for running Python scripts

## Rule Templates and Parameterization

Functions for creating parameterized and template-based rules.

- [`expandTemplate()`](https://beerda.github.io/rmake/reference/expandTemplate.md)
  :

  Expand template rules into a list of rules by replacing `rmake`
  variables with their values

- [`getParam()`](https://beerda.github.io/rmake/reference/getParam.md) :

  Wrapper around the `params` global variable

## Pipe Operator

Special operators for creating rule chains.

- [`` `%>>%` ``](https://beerda.github.io/rmake/reference/grapes-greater-than-greater-than-grapes.md)
  : A pipe operator for rmake rules

## Rule Getters

Functions to extract information from rules.

- [`prerequisites()`](https://beerda.github.io/rmake/reference/prerequisites.md)
  [`targets()`](https://beerda.github.io/rmake/reference/prerequisites.md)
  [`tasks()`](https://beerda.github.io/rmake/reference/prerequisites.md)
  [`terminals()`](https://beerda.github.io/rmake/reference/prerequisites.md)
  : Return a given set of properties of all rules in a list

## Utility Functions

Helper functions for working with rules and building.

- [`hasGnuMake()`](https://beerda.github.io/rmake/reference/hasGnuMake.md)
  : Check if GNU Make is available via the 'make' command

- [`inShell()`](https://beerda.github.io/rmake/reference/inShell.md) :
  Convert R code to a character vector of shell commands evaluating the
  given R code.

- [`is.rule()`](https://beerda.github.io/rmake/reference/is.rule.md) :
  Check if the argument is a valid rule object.

- [`sanitizePath()`](https://beerda.github.io/rmake/reference/sanitizePath.md)
  : Sanitize a file path for the current operating system

- [`sanitizeSpaces()`](https://beerda.github.io/rmake/reference/sanitizeSpaces.md)
  : Escape spaces in a string as needed in file names used in Makefile
  files

- [`replaceSuffix()`](https://beerda.github.io/rmake/reference/replaceSuffix.md)
  : Replace the suffix of a given file name with a new extension
  (suffix)

- [`replaceVariables()`](https://beerda.github.io/rmake/reference/replaceVariables.md)
  :

  Replace `rmake` variables in a character vector
