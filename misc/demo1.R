library(xprmntr)
library(magrittr)

# vector of file paths to the resources to be included
img <- c("rainbow.svg", "transgender.svg", "bisexual.svg")
img <- file.path(system.file("extdata", package = "rainbowr"), img)

# create an experiment with three trials
xpt <- jspsych_create(files = img) %>%
  jspsych_add(
    type = "image-keyboard-response",
    stimulus = resource("rainbow.svg"),
    prompt = "Do you like this flag? (Y or N)",
    choices = c(89, 78)
    ) %>%
  jspsych_add(
    type = "image-keyboard-response",
    stimulus = resource("transgender.svg"),
    prompt = "Do you like this flag? (Y or N)",
    choices = c(89, 78)
    ) %>%
  jspsych_add(
    type = "image-keyboard-response",
    stimulus = resource("bisexual.svg"),
    prompt = "Do you like this flag? (Y or N)",
    choices = c(89, 78)
    ) %>%
  jspsych_add(
    type = "survey-likert",
    questions = list(list(
      prompt = "How much did you enjoy this?",
      labels = c("a lot", "not much", "not at all"), required = TRUE))
    ) %>%
  jspsych_init(
    default_iti = 250,
    on_finish = unquote("xprmntr.save_locally"))

# write it to an html file
jspsych_write(xpt, "~/Desktop/expt")

