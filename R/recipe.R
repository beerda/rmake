recipe <- function(target, depends, build=NULL, clean=NULL) {
  structure(list(target=target,
                 depends=unique(depends),
                 build=build,
                 clean=clean),
            class='recipe')
}
