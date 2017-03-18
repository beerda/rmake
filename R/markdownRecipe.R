#' @export
markdownRecipe <- function(target,
                           script,
                           depends=NULL,
                           format=markdownFormatFromExtension(tools::file_ext(target)),
                           ...) {
  assert_that(is.string(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.string(format))

  tempDir <- paste0('.intermediate-', target)
  allDeps <- c(script, depends)
  dots <- list(...)

  recipe(target=target,
         depends=allDeps,
         # copy all dependencies to temporary subdirectory to call
         # the rendering process separately to allow parallel execution
         build=c(paste0('mkdir -p ', tempDir),
                 paste0('cp ', paste0(allDeps, collapse=' '), ' ', tempDir),
                 paste0('cd ', tempDir, '; ', inShell({
                   library(rmarkdown)
                   do.call('render', c(list(script,
                                            output_format=format,
                                            output_file=target),
                                       #output_dir=tempDir,
                                       #intermediates_dir=tempDir,
                                       #knit_root_dir=tempDir),
                                       dots))
                 })),
                 paste0('mv ', tempDir, '/', target, ' ', target),
                 paste0('$(RM) -rf ', tempDir)),
         clean=paste0('$(RM) ', target))
}
