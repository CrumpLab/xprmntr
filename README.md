
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xprmntr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/xprmntr)](https://cran.r-project.org/package=xprmntr)
<!-- badges: end -->

The goal of `xprmntr` is to let users build behavioural experiments in R
run through the browser. Initially, the intention is to provide wrappers
to the [jspsych](https://www.jspsych.org/) javascript library.

## Installation

The development version can be installed from
[GitHub](https://github.com/) with:

    # install.packages("devtools")
    devtools::install_github("djnavarro/xprmntr")

## Example

Simple example that implements a variation of demo 2 from the `jspsych`
library examples.

``` r
library(xprmntr)
library(magrittr)

# vector of file paths to the resources to be included
img <- c("rainbow.svg", "transgender.svg", "bisexual.svg")
img <- file.path(system.file("extdata", package = "rainbowr"), img)

# create an experiment with three trials
xpt <- jspsych_create(files = img) %>%
  jspsych_add(type = "image-keyboard-response", stimulus = resource("rainbow.svg"),
              prompt = "Do you like this flag? (Y or N)", choices = c(89, 78)) %>%
  jspsych_add(type = "image-keyboard-response", stimulus = resource("transgender.svg"),
              prompt = "Do you like this flag? (Y or N)", choices = c(89, 78)) %>%
  jspsych_add(type = "image-keyboard-response", stimulus = resource("bisexual.svg"),
              prompt = "Do you like this flag? (Y or N)", choices = c(89, 78)) %>%
  jspsych_add(type = "survey-likert", questions = list(list(
    prompt = "How much did you enjoy this?",
    labels = c("a lot", "not much", "not at all"), required = TRUE))) %>%
  jspsych_init(
    default_iti = 250,
    on_finish = unquote("xprmntr.save_locally"))
```

Write self-contained experiment to a directory:

``` r
jspsych_write(xpt, "~/Desktop/expt")
```

To run the experiment:

``` r
xprmntr::run_locally("~/Desktop/expt")
```
