library(knitr)
library(rvest)
library(gsubfn)
library(reshape2)
library(shiny)
library(eurostat)

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
