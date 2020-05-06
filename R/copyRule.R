#' @export
copyRule <- function(target, depends, task='all') {
  assert_that(is.string(target))
  assert_that(is.character(depends))
  assert_that(is.character(task))

  dep <- depends[1]
  if (.Platform$OS.type != 'unix') {
    dep <- gsub('/', '\\', dep, fixed=TRUE)
  }

  rule(target=target,
       depends=depends,
       build=paste0('$(CP) ', dep, ' ', target),
       clean=paste0('$(RM) ', paste0(target, collapse=' ')),
       task=task,
       type='copy')
}
