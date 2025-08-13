# rmake 1.2.0

* expandTemplate() now allows character vectors as templates
* added introductory vignette
* added subdirRule() for compilation of subdirectories
* added knitrRule() for compilation of Rnw files with knitr:knit()
* added depRule()
* enabled the depends argument of makefile() that allows the makefile generator to depend on other files
* fixed evaluation of %>>% in a function
* fixed handling of filenames with spaces in them



# rmake 1.1.0

* added %>>% pipes
* added support for rule templates
* added print() for list of rules
* added graphical visualization of dependencies



# rmake 1.0.1

* fixed unit tests for Solaris
* fixed documentation
* added make clean rules to generated Makefiles



# rmake 1.0.0

* initial version supporting rules for R script, R Markdown and offline rules
