## rendering all markdown

library(rmarkdown)

fl <- list.files(".", ".Rmd")

for (i in seq_along(f)) {
  cat(fl[i], "\n")
  flush.console()
  o <- rmarkdown::render(input=fl[i], quiet=TRUE)
  z <- rev(strsplit(o, "/")[[1]])[1]
  file.copy(
    from=o,
    to=paste0("docs/", z),
    overwrite=TRUE
  )
  unlink(o)
}
