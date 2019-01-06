okoljski_davki <- get_eurostat("env_ac_tax", time_format = "num", type = "label")
okoljski_davki <- subset(okoljski_davki, time > 2006)

vsi <- subset(okoljski_davki, tax == "Total environmental taxes")

energija <- subset(okoljski_davki, tax == "Energy taxes")
energija <- subset(energija, unit == "Million euro")
energija <- energija[-c(1,2)]
names(energija) <- c("DRŽAVA", "LETO", "DAVKI NA ENERGIJO V MILIJONIH EVROV")

onesnazevanje <- subset(okoljski_davki, tax == "Pollution taxes")
onesnazevanje <- subset(onesnazevanje, unit == "Million euro")
onesnazevanje <- onesnazevanje[-c(1,2)]
names(onesnazevanje) <- c("DRŽAVA", "LETO", "DAVKI NA ONESNAŽEVANJE V MILIJONIH EVROV")

naravni_viri <- subset(okoljski_davki, tax == "Resource taxes")
naravni_viri <- subset(naravni_viri, unit == "Million euro")
naravni_viri <- naravni_viri[-c(1,2)]
names(naravni_viri) <- c("DRŽAVA", "LETO", "DAVKI NA RABO NARAVNIH VIROV V MILIJONIH EVROV")

promet <- subset(okoljski_davki, tax == "Transport taxes")
promet <- subset(promet, unit == "Million euro")
promet <- promet[-c(1,2)]
names(promet) <- c("DRŽAVA", "LETO", "DAVKI NA PROMET V MILIJONIH EVROV")

tabela3 <- join(energija, onesnazevanje, type = "inner")
tabela3 <- join(tabela3, naravni_viri, type = "inner")
tabela3 <- join(tabela3, promet, type = "inner")

tabela3$"OKOLJSKI DAVKI V MILIJONIH EVROV" <-
  tabela3$"DAVKI NA ENERGIJO V MILIJONIH EVROV" +
  tabela3$"DAVKI NA ONESNAŽEVANJE V MILIJONIH EVROV" +
  tabela3$"DAVKI NA RABO NARAVNIH VIROV V MILIJONIH EVROV" +
  tabela3$"DAVKI NA PROMET V MILIJONIH EVROV"

write.csv(tabela3, file = "davki.csv")
