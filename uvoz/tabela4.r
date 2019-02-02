library(eurostat)
library(dplyr)
library(plyr)

tab <- get_eurostat('ten00049', time_format = "num", type = "label", stringsAsFactors = FALSE)
tab <- filter(tab, time > 2006)
tab <- tab[-c(2,3, 4)]

javni_sektor <- filter(tab, env_exp == "Total environmental current expenditure")
javni_sektor <- javni_sektor[-c(1)]
names(javni_sektor) <- c("DRZAVA", "LETO", "DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU JAVNEGA SEKTORJA")

javni_sektor_investicije <- filter(tab, env_exp == "Total environmental investments")
javni_sektor_investicije <- javni_sektor_investicije[-c(1)]
names(javni_sektor_investicije) <- c("DRZAVA", "LETO", "DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V JAVNEM SEKTORJU")


tab2 <- get_eurostat("ten00052", time_format = "num", type = "label")
tab2 <- filter(tab2, time > 2006)
tab2 <- tab2[-c(2, 3, 4)]

industrija <- filter(tab2, env_exp == "Total environmental current expenditure")
industrija <- industrija[-c(1)]

names(industrija) <- c("DRZAVA", "LETO", "DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU INDUSTRIJE")

industrija_investicije <- filter(tab2, env_exp == "Total environmental investments")
industrija_investicije <- industrija_investicije[-c(1)]
names(industrija_investicije) <- c("DRZAVA", "LETO", "DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V INDUSTRIJI")

tabela4 <- join(javni_sektor, industrija, type = "inner")
tabela4 <- join(tabela4, javni_sektor_investicije, type = "inner") 
tabela4 <- join(tabela4, industrija_investicije, type = "inner")
tabela4$DRZAVA <- gsub("Euro.*", "", tabela4$DRZAVA)
tabela4 <- subset(tabela4, DRZAVA!="")

tabela4$DRZAVA <- replace(tabela4$DRZAVA, tabela4$DRZAVA=="Germany (until 1990 former territory of the FRG)", "Germany")

DRZAVA <- c(unique(tabela4$DRZAVA))
c2 <- c("Avstrija", "Belgija", "Bolgarija", "Češka", "Nemčija", "Estonija",
        "Španija", "Finska", "Francija", "Hrvaška", "Madžarska", "Italija",
        "Litva", "Latvija", "Nizozemska", "Poljska", "Portugalska", "Romunija",
        "Srbija", "Švedska", "Slovenija", "Slovaška", "Turčija", "Velika Britanija",
        "Norveška", "Ciper")
c3 <- data.frame(DRZAVA,c2)
tabela4 <- left_join(tabela4, c3)
tabela4 <- tabela4[-c(1)]
tabela4 <- tabela4[c(6,1,2,3,4,5)]
names(tabela4)[1] <- "DRZAVA"
