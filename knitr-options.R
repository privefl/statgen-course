knitr::opts_chunk$set(
  comment = "#>",
  out.width = "70%",
  fig.align = "center",
  dev = "png"
)

options(width = 75)

Sys.setenv(LANGUAGE = "en")
Sys.setlocale("LC_TIME", "C")

FA_ICON_R <- icons::fontawesome$brands$`r-project`

system <- function(...) {
  if (isTRUE(list(...)$intern)) {
    base::system(...)
  } else {
    cat(base::system(..., intern = TRUE), sep = '\n')
  }
}
env_bigsnpr <- asNamespace("bigsnpr")
rlang::env_unlock(env = env_bigsnpr)
rlang::env_binding_unlock(env = env_bigsnpr)
assign("system", system, envir = env_bigsnpr)
rlang::env_binding_lock(env = env_bigsnpr)
rlang::env_lock(env_bigsnpr)
