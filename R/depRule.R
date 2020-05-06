#' @export
depRule <- function(target, depends=NULL, task='all') {
  rule(target=target,
       depends=depends,
       task=task,
       type='dependency')
}
