.optionsFactory <- function() {
  defaults <- list(
    'R.command'='R --no-save --no-restore -quiet -e',
    'rm.command'='rm'
  )

  list(
    get=function(name) { defaults[[name]] },
    set=function(name, value) { defaults[[name]] <<- value }
  )
}

maker <- .optionsFactory()
