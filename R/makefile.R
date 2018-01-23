#' Variables used within Makefile generating process
#'
#' `defaultVars` is a reserved variable, a named vector that defines
#' Makefile variables, i.e. shell variables that will exist during
#' the execution of Makefile recipes. The content of this variable
#' is written into the resulting Makefile withen the execution of
#' the [makefile()] function.
#' @seealso [makefile()]
#' @author Michal Burda
#' @export
defaultVars <- c(R='R --no-save --no-restore --quiet',
                 RM='rm')


.taskDependencies <- function(job, task) {
  r <- lapply(job, function(recipe) {
    ifelse(task %in% recipe$task, list(recipe$target), list())
  })
  unlist(r)
}


#' Generate Makefile from given list of recipes (`job`).
#'
#' In the (GNU) `make` jargon, *recipe* is an atomic build process unit. In this package, recipe
#' should be understood similarly: It is a command that optionally produces some files while depending
#' on some other files (or recipes). Moreover, a recipe may contain a command for cleanup, i.e. removal
#' of generated files.
#'
#' The [makefile()] function takes a list of recipes (see [recipe()]) and generates a `Makefile` from them.
#' Additionally, `all` and `clean` recipes are optionally generated too.
#'
#' If there is a need to group some recipes into a group, it can be done either via dependencies or by using
#' the `task` mechanism. Each recipe may get assigned one or more tasks (see `task` in [recipe()]). Each
#' task is then created as a standalone recipe depending on assigned recipes. That way, executing `make task_name`
#' will build all recipes with assigned task `task_name`. By default, all recipes are assigned to task `all`,
#' which allows `make all` to build everything.
#'
#' @param job A list of recipes (i.e. of instances of the S3 class `recipe` - see [recipe()])
#' @param fileName A file to write to. If `NULL`, the result is returned as a character vector instead of
#' writing to a file.
#' @param makeScript A name of the file that calls this function (in order to generate
#' the `makefile` recipe)
#' @param vars A named character vector of shell variables that will be declared in the resulting Makefile
#' (additionally to `[defaultVars]`)
#' @param all `TRUE` if the `all` recipe should be automatically created and added: created `all` recipe
#' has dependencies to all the other recipes, which causes that everything is built if `make all` is executed
#' in shell's command line.
#' @param tasks `TRUE` if "task" recipes should be automatically created and added -- see [recipe()] for
#' more details.
#' @param clean `TRUE` if the `clean` recipe should be automatically created and added
#' @param makefile `TRUE` if the `Makefile` recipe should be automatically created and added: this recipe
#' causes that any change in the R script - that generates the `Makefile` (i.e. that calls [makefile()]) -
#' issues the re-generation of the Makefile in the beginning of any build.
#' @return If `fileName` is `NULL`, the function returns a character vector with the contents of the
#' Makefile.
#' @seealso [recipe()], [makerSkeleton()]
#' @author Michal Burda
#' @export
#' @import assertthat
makefile <- function(job=list(),
                     fileName='Makefile',
                     makeScript='Makefile.R',
                     vars=NULL,
                     all=TRUE,
                     tasks=TRUE,
                     clean=TRUE,
                     makefile=TRUE) {
  assert_that(is.list(job))
  assert_that(all(vapply(job, is.recipe, logical(1))))
  assert_that(is.null(fileName) || is.string(fileName))
  assert_that(is.string(makeScript))
  if (!is.null(vars)) {
    assert_that(is.character(vars))
    assert_that(!is.null(names(vars)))
    assert_that(is.character(names(vars)))
    assert_that(all(names(vars) != ""))
  }
  assert_that(is.flag(all))
  assert_that(is.flag(tasks))
  assert_that(is.flag(clean))
  assert_that(is.flag(makefile))

  if (tasks) {
    uniqueTaskNames <- unique(unlist(lapply(job, function(recipe) recipe$task)))
    for (task in rev(uniqueTaskNames)) {
      if (task != 'all') {
        taskRecipe <- recipe(target=task,
                             depends=.taskDependencies(job, task))
        job <- c(list(taskRecipe), job)
      }
    }
  }

  if (all) {
    allRecipe <- recipe(target='all',
                        depends=.taskDependencies(job, 'all'))
    job <- c(list(allRecipe), job)
  }

  if (clean) {
    cleans <- unique(unlist(lapply(job, function(recipe) recipe$clean)))
    if (!is.null(cleans) && length(cleans) > 0) {
      cleanRecipe <- recipe(target='clean',
                            depends=NULL,
                            build=cleans)
      job <- c(job, list(cleanRecipe))
    }
  }

  if (makefile) {
    target <- fileName
    if (is.null(target)) {
      target <- 'Makefile'
    }
    makefileRecipe <- rRecipe(target=target, script=makeScript)
    job <- c(job, list(makefileRecipe))
  }

  v <- defaultVars
  v[names(vars)] <- vars
  preambleRows <- c('# Generated by maker: do not edit by hand',
                    paste0(names(v), '=', v))

  recipeRows <- lapply(job, function(recipe) {
    c(paste0(paste0(recipe$pattern, collapse=' '),
             ': ',
             paste0(recipe$depends, collapse=' ')),
      paste0('\t', recipe$build))
  })
  recipeRows <- unlist(recipeRows)

  rows <- c(preambleRows, '', recipeRows)
  if (!is.null(fileName)) {
    cat(rows, sep='\n', file=fileName)
  } else {
    return(rows)
  }
}
