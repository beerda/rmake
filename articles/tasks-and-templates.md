# Tasks and Templates

## Introduction

This vignette covers advanced features of `rmake` that help manage
complex build processes: **tasks** for organizing and selectively
executing groups of rules, and **templates** for efficiently generating
multiple similar rules with parameterization.

For basic usage and an introduction to rmake, see the **Getting Started
with rmake** vignette. For information on specific rule types, see the
**Build Rules** vignette. For project management basics, see the **rmake
Project Management** vignette.

## Tasks

Tasks allow grouping rules that can be executed together. Each rule is a
member of the `"all"` task by default. Rules can belong to multiple
tasks.

### Executing Tasks

Execute a task:

``` r
make('all')
make('preview')
```

### Assigning Rules to Tasks

Assign rules to tasks:

``` r
library(rmake)
job <- c(
  "data.csv" %>>% rRule("preprocess.R") %>>% "data.rds",
  "data.rds" %>>% markdownRule("preview.Rmd", task = "preview") %>>% 
    "preview.pdf",
  "data.rds" %>>% markdownRule("final.Rmd", task = "final") %>>% 
    "final.pdf"
)
makefile(job, "Makefile")
```

Running `make("preview")` creates `data.rds` and `preview.pdf` but not
`final.pdf`.

### Use Cases for Tasks

Tasks are useful for:

- **Incremental development**: Create a “preview” task for quick
  iterations and a “final” task for complete analysis
- **Different outputs**: Separate tasks for different report formats or
  audiences
- **Testing**: Create a “test” task that runs on sample data before
  processing the full dataset

## Parameterized Execution

Pass parameters to scripts via the `params` argument:

``` r
library(rmake)
job <- c(
  "data.csv" %>>% rRule("fit.R", params = list(alpha = 0.1)) %>>% "out-0.1.rds",
  "data.csv" %>>% rRule("fit.R", params = list(alpha = 0.2)) %>>% "out-0.2.rds",
  "data.csv" %>>% rRule("fit.R", params = list(alpha = 0.3)) %>>% "out-0.3.rds"
)
makefile(job, "Makefile")
```

### Accessing Parameters in Scripts

Parameters are available in scripts as the `params` global variable:

``` r
# fit.R
str(params)
# List of 5
#  $ .target : chr "out-0.1.rds"
#  $ .script : chr "fit.R"
#  $ .depends: chr "data.csv"
#  $ .task   : chr "all"
#  $ alpha   : num 0.1
```

### Using getParam()

Use [`getParam()`](https://beerda.github.io/rmake/reference/getParam.md)
to access parameters safely:

``` r
# fit.R
library(rmake)

dataName <- getParam(".depends")
resultName <- getParam(".target")
alpha <- getParam("alpha")

# Use parameters...
cat("Processing with alpha =", alpha, "\n")
```

[`getParam()`](https://beerda.github.io/rmake/reference/getParam.md)
with default values:

``` r
dataName <- getParam(".depends", "data.csv")
resultName <- getParam(".target", "result.rds")
alpha <- getParam("alpha", 0.2)
```

### Built-in Parameters

Every rule automatically has the following parameters available:

- `.target` - The target file(s) being created
- `.script` - The script being executed
- `.depends` - The dependency file(s)
- `.task` - The task name(s)

## Rule Templates

Rule templates avoid repetitive rule definitions using
[`expandTemplate()`](https://beerda.github.io/rmake/reference/expandTemplate.md).
This is particularly useful when you need to run the same analysis with
different parameters or on different datasets.

### Simple Template

``` r
tmpl <- "data-$[NUM].csv" %>>% 
  rRule("process.R") %>>% 
  "result-$[NUM].csv"
variants <- data.frame(NUM = 1:99)
job <- expandTemplate(tmpl, variants)
```

This creates 99 rules, one for each value of `NUM`.

### Template with Multiple Variables

``` r
variants <- expand.grid(DATA = c("dataSimple", "dataComplex"),
                        TYPE = c("lm", "rf", "nnet"))
print(variants)
#>          DATA TYPE
#> 1  dataSimple   lm
#> 2 dataComplex   lm
#> 3  dataSimple   rf
#> 4 dataComplex   rf
#> 5  dataSimple nnet
#> 6 dataComplex nnet

tmpl <- "$[DATA].csv" %>>% 
  rRule("fit-$[TYPE].R") %>>%
  "result-$[DATA]_$[TYPE].csv"
job <- expandTemplate(tmpl, variants)
print(job)
#> [[1]]
#> (fit-lm.R, dataSimple.csv) -> R -> (result-dataSimple_lm.csv)
#> [[2]]
#> (fit-lm.R, dataComplex.csv) -> R -> (result-dataComplex_lm.csv)
#> [[3]]
#> (fit-rf.R, dataSimple.csv) -> R -> (result-dataSimple_rf.csv)
#> [[4]]
#> (fit-rf.R, dataComplex.csv) -> R -> (result-dataComplex_rf.csv)
#> [[5]]
#> (fit-nnet.R, dataSimple.csv) -> R -> (result-dataSimple_nnet.csv)
#> [[6]]
#> (fit-nnet.R, dataComplex.csv) -> R -> (result-dataComplex_nnet.csv)
```

### Combining Templates with Parameters

Duplicate rules are automatically removed:

``` r
tmpl <- "data.csv" %>>%
  rRule("pre.R") %>>% "pre.rds" %>>%
  rRule("comp.R", params = list(alpha = "$[NUM]")) %>>% 
  "result-$[NUM].csv"
variants <- data.frame(NUM = 1:5)
job <- expandTemplate(tmpl, variants)
#> Warning in expandTemplate(tmpl, variants): Converting all values in `vars` to
#> character vectors.
print(job)
#> [[1]]
#> (pre.R, data.csv) -> R -> (pre.rds)
#> [[2]]
#> (comp.R, pre.rds) -> R -> (result-1.csv)
#> [[3]]
#> (comp.R, pre.rds) -> R -> (result-2.csv)
#> [[4]]
#> (comp.R, pre.rds) -> R -> (result-3.csv)
#> [[5]]
#> (comp.R, pre.rds) -> R -> (result-4.csv)
#> [[6]]
#> (comp.R, pre.rds) -> R -> (result-5.csv)
```

### Template Variables in Parameters

Template variables (like `$[NUM]`) can be used in: - File names (targets
and dependencies) - Script names - Parameters passed to rules

### Common Pitfall: Multiple Rules for Same Target

Warning: Different rules producing the same target will cause an error:

``` r
tmpl <- "data-$[TYPE].csv" %>>% 
  markdownRule("report.Rmd") %>>% "report.pdf"
variants <- data.frame(TYPE = c("a", "b", "c"))
job <- expandTemplate(tmpl, variants)
print(job)
#> [[1]]
#> (report.Rmd, data-a.csv) -> markdown -> (report.pdf)
#> [[2]]
#> (report.Rmd, data-b.csv) -> markdown -> (report.pdf)
#> [[3]]
#> (report.Rmd, data-c.csv) -> markdown -> (report.pdf)

# This would error:
# makefile(job)
# Error: Multiple rules detected for the same target
```

## Combining Tasks and Templates

You can combine tasks and templates for powerful workflow management:

``` r
# Create template for different models
tmpl <- "data.csv" %>>% 
  rRule("fit-$[MODEL].R", params = list(model = "$[MODEL]")) %>>%
  "model-$[MODEL].rds"

# Expand for different models
variants <- data.frame(MODEL = c("linear", "rf", "xgboost"))
training_job <- expandTemplate(tmpl, variants)

# Add evaluation tasks
eval_job <- c(
  c("model-linear.rds", "model-rf.rds", "model-xgboost.rds") %>>%
    rRule("evaluate.R") %>>% "evaluation.rds",
  "evaluation.rds" %>>% 
    markdownRule("report.Rmd", task = "report") %>>% "report.pdf"
)

# Combine all rules
job <- c(training_job, eval_job)
makefile(job, "Makefile")
```

## Best Practices

### For Tasks

1.  **Use meaningful names**: Choose task names that clearly describe
    their purpose
2.  **Keep “all” minimal**: Only include essential outputs in the
    default “all” task
3.  **Create incremental tasks**: Build up complexity with tasks like
    “quick”, “full”, “validate”

### For Templates

1.  **Use data frames for variants**: This makes it easy to generate all
    combinations with
    [`expand.grid()`](https://rdrr.io/r/base/expand.grid.html)
2.  **Test with small variants first**: Before generating hundreds of
    rules, test with 2-3 variants
3.  **Use consistent naming**: Develop a naming convention for template
    variables
4.  **Document your templates**: Add comments explaining what each
    template generates

## Summary

This vignette covered:

- **Tasks**: Organizing rules into groups that can be executed
  selectively
- **Parameterized Execution**: Passing parameters to scripts for
  flexible processing
- **Rule Templates**: Efficiently generating multiple similar rules
- **Combining Features**: Using tasks and templates together for complex
  workflows

For more information on basic usage and rule types, see the other
vignettes: - “Getting Started with rmake” - “rmake Project Management” -
“Build Rules”
