#' @export
copyRule <- function(target, depends, task='all') {
  assert_that(is.string(target))
  assert_that(is.character(depends))
  assert_that(is.character(task))

  rule(target=target,
       depends=depends,
       build=paste0('$(CP) ', sanitizePath(depends[1]), ' ', sanitizePath(target)),
       clean=paste0('$(RM) ', paste0(sanitizePath(target), collapse=' ')),
       task=task,
       type='copy')
}
