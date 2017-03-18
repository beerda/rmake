#' @export
makefile <- function(job=list(), fileName='Makefile') {
  assert_that(is.list(job))
  assert_that(all(vapply(job, is.recipe, logical(1))))
  assert_that(is.null(fileName) || is.string(fileName))

  targets <- unlist(lapply(job, function(recipe) recipe$target))
  allRecipe <- recipe(target='all',
                      depends=targets,
                      build=NULL)
  job <- c(list(allTask), job)

  cleans <- lapply(job, function(recipe) recipe[['clean']])
  if (!is.null(cleans) && length(cleans) > 0) {
    cleanRecipe <- reciipe(target='clean',
                           depends=NULL,
                           build=unlist(cleans))
    job <- c(job, list(cleanRecipe))
  }

  makefileRecipe <- rRecipe(target='Makefile', script='Makefile.R')
  job <- c(job, list(makefileRecipe))

  cmdTabs <- lapply(job, function(recipe) nchar(recipe$target))
  cmdTabs <- floor((1 + max(unlist(cmdTabs))) / 8) + 1
  cmdTabs <- paste0(rep('\t', cmdTabs), collapse='')

  rows <- lapply(job, function(recipe) {
    depTabs <- nchar(cmdTabs) - floor(1 + (nchar(recipe$target) / 8)) + 1
    depTabs <- paste0(rep('\t', depTabs), collapse='')
    paste0(recipe$target, ':', depTabs, paste(recipe$depends, collapse=' '), '\n',
           paste0(cmdTabs, recipe$build, collapse='\n'), '\n')
  })

  conn <- stdout()
  if (!is.null(fileName)) {
    conn <- file(fileName, "w")
  }
  writeLines(unlist(rows), conn)
  if (!is.null(fileName)) {
    close(conn)
  }
}
