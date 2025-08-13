#' Variables used within Makefile generating process
#'
#' `defaultVars` is a reserved variable, a named vector that defines
#' Makefile variables, i.e. shell variables that will exist during
#' the execution of Makefile rules. The content of this variable
#' is written into the resulting Makefile within the execution of
#' the [makefile()] function.
#' @seealso [makefile()]
#' @author Michal Burda
#' @export
defaultVars <- c(SHELL='/bin/sh',
                 R='"$(R_HOME)/bin$(R_ARCH)/Rscript"',
                 RM=ifelse(.Platform$OS.type == 'unix', 'rm', 'cmd //C del'),
                 CP=ifelse(.Platform$OS.type == 'unix', 'cp', 'cmd //C copy'))


.taskDependencies <- function(job, task) {
  r <- lapply(job, function(rule) {
    ifelse(task %in% rule$task, list(rule$target), list())
  })
  unlist(r)
}


.allTasks <- function(job) {
  tasks <- lapply(job, function(rule) rule$task)
  tasks <- unlist(tasks)
  unique(c('all', tasks))
}


.validate <- function(job) {
  assert_that(is.list(job))
  assert_that(all(vapply(job, is.rule, logical(1))))

  # search for duplicate targets
  targets <- lapply(job, function(r) r$target)
  dupl <- duplicated(targets)
  if (any(dupl)) {
    dupl <- unique(targets[dupl])
    stop(paste0('Duplicate targets found: ', paste(dupl, collapse=', ')))
  }

  # search for non-evaluated variables
  chars <- lapply(job, function(r) {
    unlist(r[sapply(r, is.character)])
  })
  chars <- as.vector(unlist(chars))
  vars <- grep('\\$\\[[^]]*\\]', chars, value=TRUE)
  if (length(vars) > 0L) {
    stop(paste0('Non-evaluated rmake variables found in: ',
                paste(unique(vars), collapse=', ')))
  }
}


#' Generate Makefile from given list of rules (`job`).
#'
#' In the (GNU) `make` jargon, *rule* is a sequence of commands to build a result. In this package, rule
#' should be understood similarly: It is a command or a sequence of command that optionally produces some
#' files and depends on some other files (such as data files, scripts) or other rules. Moreover, a rule
#' contain a command for cleanup, i.e. for removal of generated files.
#'
#' The [makefile()] function takes a list of rules (see [rule()]) and generates a `Makefile` from them.
#' Additionally, `all` and `clean` rules are optionally generated too, which can be executed from shell
#' by issuing `make all` or `make clean` command, respectively, in order to build everything or erase all
#' generated files.
#'
#' If there is a need to group some rules into a group, it can be done either via dependencies or by using
#' the `task` mechanism. Each rule may get assigned one or more tasks (see `task` in [rule()]). Each
#' task is then created as a standalone rule depending on assigned rules. That way, executing `make task_name`
#' will build all rules with assigned task `task_name`. By default, all rules are assigned to task `all`,
#' which allows `make all` to build everything.
#'
#' @param job A list of rules (i.e. of instances of the S3 class `rmake.rule` - see [rule()])
#' @param fileName A file to write to. If `NULL`, the result is returned as a character vector instead of
#' writing to a file.
#' @param makeScript A name of the file that calls this function (in order to generate
#' the `makefile` rule)
#' @param vars A named character vector of shell variables that will be declared in the resulting Makefile
#' (additionally to `[defaultVars]`)
#' @param all `TRUE` if the `all` rule should be automatically created and added: created `all` rule
#' has dependencies to all the other rules, which causes that everything is built if `make all` is executed
#' in shell's command line.
#' @param tasks `TRUE` if "task" rules should be automatically created and added -- see [rule()] for
#' more details.
#' @param clean `TRUE` if the `clean` rule should be automatically created and added
#' @param makefile `TRUE` if the `Makefile` rule should be automatically created and added: this rule
#' causes that any change in the R script - that generates the `Makefile` (i.e. that calls [makefile()]) -
#' issues the re-generation of the Makefile in the beginning of any build.
#' @param depends a character vector of file names that the makefile generating script depends on
#' @return If `fileName` is `NULL`, the function returns a character vector with the contents of the
#' Makefile. Instead, the content is written to the given `fileName`.
#' @seealso [rule()], [rmakeSkeleton()]
#' @author Michal Burda
#' @examples
#' # create some jobs
#' job <- list(
#'     rRule('dataset.rds', 'preprocess.R', 'dataset.csv'),
#'     markdownRule('report.pdf', 'report.Rmd', 'dataset.rds'),
#'     markdownRule('details.pdf', 'details.Rmd', 'dataset.rds'))
#'
#' # generate Makefile (output as a character vector)
#' makefile(job)
#'
#' # generate to file
#' tmp <- tempdir()
#' makefile(job, file.path(tmp, "Makefile"))
#' @export
#' @import assertthat
makefile <- function(job=list(),
                     fileName=NULL,
                     makeScript='Makefile.R',
                     vars=NULL,
                     all=TRUE,
                     tasks=TRUE,
                     clean=TRUE,
                     makefile=TRUE,
                     depends=NULL) {
  assert_that(is.list(job))
  assert_that(all(vapply(job, is.rule, logical(1))))
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

  makefileName <- NULL
  if (makefile) {
    makefileName <- fileName
    if (is.null(makefileName)) {
      makefileName <- 'Makefile'
    }
  }

  job <- unique(job)
  .validate(job)

  if (tasks) {
    uniqueTaskNames <- unique(unlist(lapply(job, function(rule) rule$task)))
    for (task in rev(uniqueTaskNames)) {
      if (task != 'all') {
        taskRule <- rule(target=task,
                         depends=c(makefileName, .taskDependencies(job, task)),
                         phony=TRUE)
        job <- c(list(taskRule), job)
      }
    }
  }

  if (all) {
    allRule <- rule(target='all',
                    depends=c(makefileName, .taskDependencies(job, 'all')),
                    phony=TRUE)
    job <- c(list(allRule), job)
  }

  if (clean) {
    cleans <- unique(unlist(lapply(job, function(rule) rule$clean)))
    if (!is.null(cleans) && length(cleans) > 0) {
      cleanRule <- rule(target='clean',
                            depends=NULL,
                            build=cleans,
                            phony=TRUE)
      job <- c(job, list(cleanRule))
    }

    # generate clean_<task> rules
    if (tasks) {
      uniqueTaskNames <- unique(unlist(lapply(job, function(rule) rule$task)))
      for (task in uniqueTaskNames) {
        if (task != 'all') {
          cleans <- unique(unlist(lapply(job, function(rule) {
            if (task %in% rule$task) {
              return(rule$clean)
            } else {
              return(NULL)
            }
          })))
          taskCleanRule <- rule(target=paste0('clean_', task),
                               depends=NULL,
                               build=cleans,
                               phony=TRUE)
          job <- c(job, list(taskCleanRule))
        }
      }
    }
  }

  if (makefile) {
    makefileRule <- rRule(target=makefileName, script=makeScript, depends=depends)
    job <- c(job, list(makefileRule))
  }

  v <- defaultVars
  v[names(vars)] <- vars
  preambleRows <- c('# Generated by rmake: do not edit by hand',
                    paste0(names(v), '=', v))

  ruleRows <- lapply(job, function(rule) {
    pattern <- sanitizeSpaces(rule$pattern)
    depends <- sanitizeSpaces(rule$depends)
    build <- rule$build
    res <- c(paste0(paste0(pattern, collapse=' '),
                    ': ',
                    paste0(depends, collapse=' ')),
             paste0('\t', build))
    if (isTRUE(rule$phony)) {
      res <- c(paste0('.PHONY: ', pattern),
               res)
    }
    return(res)
  })

  ruleRows <- unlist(ruleRows)

  rows <- c(preambleRows, '', ruleRows)
  if (!is.null(fileName)) {
    cat(rows, sep='\n', file=fileName)
  } else {
    return(rows)
  }
}
