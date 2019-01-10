library(eurostat)
library(dplyr)
library(plyr)

tab <- get_eurostat('ten00049', time_format = "num", type = "label")
tab <- filter(tab, time > 2006)
tab <- tab[-c(2,3, 4)]

javni_sektor <- filter(tab, env_exp == "Total environmental current expenditure")
javni_sektor <- javni_sektor[-c(1)]
names(javni_sektor) <- c("DRŽAVA", "LETO", "DELEŽ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU JAVNEGA SEKTORJA")

javni_sektor_investicije <- filter(tab, env_exp == "Total environmental investments")
javni_sektor_investicije <- javni_sektor_investicije[-c(1)]
names(javni_sektor_investicije) <- c("DRŽAVA", "LETO", "DELEŽ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V JAVNEM SEKTORJU")


tab2 <- get_eurostat("ten00052", time_format = "num", type = "label")
tab2 <- filter(tab2, time > 2006)
tab2 <- tab2[-c(2, 3, 4)]

industrija <- filter(tab2, env_exp == "Total environmental current expenditure")
industrija <- industrija[-c(1)]

names(industrija) <- c("DRŽAVA", "LETO", "DELEŽ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU INDUSTRIJE")

industrija_investicije <- filter(tab2, env_exp == "Total environmental investments")
industrija_investicije <- industrija_investicije[-c(1)]
names(industrija_investicije) <- c("DRŽAVA", "LETO", "DELEŽ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V INDUSTRIJI")

tabela4 <- join(javni_sektor, industrija, type = "inner")
tabela4 <- join(tabela4, javni_sektor_investicije, type = "inner") 
tabela4 <- join(tabela4, industrija_investicije, type = "inner") 