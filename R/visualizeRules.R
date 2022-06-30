#' Visualize dependencies defined by a rule or a list of rules
#'
#' @param x An instance of the S3 `rmake.rule` class or a list of such objects
#' @param legend Whether to draw a legend
#' @seealso [makefile()], [rule()]
#' @author Michal Burda
#' @examples
#' job <- c('data1.csv', 'data2.csv') %>>%
#'   rRule('process.R') %>>%
#'   'data.rds' %>>%
#'   markdownRule('report.Rmd') %>>%
#'   'report.pdf'
#'
#' \dontrun{
#' visualizeRules(job)
#' }
#' @export
#' @importFrom visNetwork visNetwork
#' @importFrom visNetwork visEdges
#' @importFrom visNetwork visLegend
#' @importFrom tools file_ext
visualizeRules <- function(x, legend=TRUE) {
  if (is.rule(x)) {
    x <- list(x)
  }
  assert_that(is.list(x))
  assert_that(all(vapply(x, is.rule, logical(1))))

  .isSpecial <- function(name) {
    tolower(file_ext(name)) %in% c('r', 'rmd', 'rnw')
  }

  x <- unique(x)
  nodes <- data.frame()
  edges <- data.frame()
  for (i in seq_along(x)) {
    r <- x[[i]]
    id <- paste0(i, ':', r$type)
    edges <- rbind(edges, data.frame(from=r$depends, to=id))
    edges <- rbind(edges, data.frame(from=id, to=r$target))
    nodes <- rbind(nodes, data.frame(id=id, group='exec', label=r$type))
    nodes <- rbind(nodes, data.frame(id=r$depends,  group='file', label=r$depends))
    nodes <- rbind(nodes, data.frame(id=r$target, group='file', label=r$target))
  }
  nodes <- unique(nodes)
  nodes[nodes$group == 'exec', 'shape'] <- 'ellipse'
  nodes[nodes$group == 'exec', 'color'] <- 'lightblue'
  nodes[nodes$group == 'file' & .isSpecial(nodes$id), 'shape'] <- 'diamond'
  nodes[nodes$group == 'file' & !.isSpecial(nodes$id), 'shape'] <- 'square'
  nodes[nodes$group == 'file' & .isSpecial(nodes$id), 'color'] <- 'gray'
  nodes[nodes$group == 'file' & !.isSpecial(nodes$id), 'color'] <- 'lightgray'

  g <- visNetwork(nodes, edges)
  g <- visEdges(g, arrows='to')
  if (legend) {
    g <- visLegend(g,
                   useGroups=FALSE,
                   addNodes=data.frame(label=c('rule', 'code file', 'data file'),
                                       shape=c('ellipse', 'diamond', 'square'),
                                       color=c('lightblue', 'gray', 'lightgray')))
  }
  g
}
