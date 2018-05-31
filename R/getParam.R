getParam <- function(name, default=NA) {
  if (!exists('params')) {
    warning(paste0('rmake parameters not found - using default value for "', name, '": ', default))
    return(default)
  } else {
    p <- get('params', envir=.GlobalEnv)
    if (is.list(p) && is.element(name, names(p))) {
      return(p[[name]])
    } else {
      stop(paste0('rmake parameter "', name, '" is required'))
    }
  }
}
