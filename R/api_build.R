# file: api_build.R
# author: Danielle Navarro

#' Run a jspsych experiment
#'
#' @param path path
#' @param show_in string, "viewer" to show in viewer, or "browser" to show in browser
#' @param xprmntr_host host defaults to 127.0.0.1
#' @param xprmntr_port port defaults to 8000
#' @export
run_locally <- function(path = ".",
                        show_in = "viewer",
                        xprmntr_host = "127.0.0.1",
                        xprmntr_port = 8000) {

  pr <- plumber::plumber$new()

  static_site <- file.path(path, "experiment")
  data_folder <- file.path(path, "data")
  static_router <- plumber::PlumberStatic$new(static_site)

  pr$mount("/", static_router)
  pr$handle("POST", "/submit", function(req, res){

    dat <- jsonlite::fromJSON(req$postBody)
    dat <- readr::read_csv(dat$filedata)
    tsp <- get_timestamp()
    file_id <- paste("data", get_timestamp(), get_alphanumeric(10), sep = "_")
    dat$file_id <- file_id
    dat <- dat[, c(ncol(dat), 1:ncol(dat)-1), drop = FALSE]
    readr::write_csv(dat, file.path(data_folder, paste0(file_id, ".csv")))
  })

  # add message, and options to display in viewer or browser
  message(paste("Point the browser to http://",xprmntr_host,":",xprmntr_port, sep=""))

  if(show_in == "viewer"){
    viewer <- getOption("viewer")
    viewer(paste("http://",xprmntr_host,":",xprmntr_port, sep=""))
  }
  if(show_in == "browser") utils::browseURL(paste("http://",xprmntr_host,":",xprmntr_port, sep=""))
  #

  pr$run(swagger = FALSE, host=xprmntr_host, port= xprmntr_port)

}
