library(eurostat)

okoljski_davki <- get_eurostat("env_ac_tax", time_format = "num", type = "label", stringsAsFactors = FALSE)
okoljski_davki <- subset(okoljski_davki, time > 2006)

vsi <- subset(okoljski_davki, tax == "Total environmental taxes")

energija <- subset(okoljski_davki, tax == "Energy taxes")
energija <- subset(energija, unit == "Million euro")
energija <- energija[-c(1,2)]
names(energija) <- c("DRZAVA", "LETO", "DAVKI NA ENERGIJO V MILIJONIH EVROV")

onesnazevanje <- subset(okoljski_davki, tax == "Pollution taxes")
onesnazevanje <- subset(onesnazevanje, unit == "Million euro")
onesnazevanje <- onesnazevanje[-c(1,2)]
names(onesnazevanje) <- c("DRZAVA", "LETO", "DAVKI NA ONESNAZEVANJE V MILIJONIH EVROV")

naravni_viri <- subset(okoljski_davki, tax == "Resource taxes")
naravni_viri <- subset(naravni_viri, unit == "Million euro")
naravni_viri <- naravni_viri[-c(1,2)]
names(naravni_viri) <- c("DRZAVA", "LETO", "DAVKI NA RABO NARAVNIH VIROV V MILIJONIH EVROV")

promet <- subset(okoljski_davki, tax == "Transport taxes")
promet <- subset(promet, unit == "Million euro")
promet <- promet[-c(1,2)]
names(promet) <- c("DRZAVA", "LETO", "DAVKI NA PROMET V MILIJONIH EVROV")

tabela3 <- inner_join(energija, onesnazevanje)
tabela3 <- inner_join(tabela3, naravni_viri)
tabela3 <- inner_join(tabela3, promet)

tabela3$"OKOLJSKI DAVKI V MILIJONIH EVROV" <-
  tabela3$"DAVKI NA ENERGIJO V MILIJONIH EVROV" +
  tabela3$"DAVKI NA ONESNAZEVANJE V MILIJONIH EVROV" +
  tabela3$"DAVKI NA RABO NARAVNIH VIROV V MILIJONIH EVROV" +
  tabela3$"DAVKI NA PROMET V MILIJONIH EVROV"

tabela3$DRZAVA <- replace(tabela3$DRZAVA, tabela3$DRZAVA=="Germany (until 1990 former territory of the FRG)", "Germany")