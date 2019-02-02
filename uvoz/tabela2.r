library(eurostat)
library(dplyr)
library(eurostat)

prebivalci <- get_eurostat('demo_pjan', time_format = "num", type = "label")
prebivalci <- subset(prebivalci, time > 2006)
prebivalci <- subset(prebivalci, sex == 'Total')
prebivalci <- subset(prebivalci, age == 'Total')
prebivalci <- prebivalci[,-c(1,2,3)]
names(prebivalci) <- (c("DRZAVA", "LETO", "STEVILO PREBIVALCEV"))

bdp <- get_eurostat("nama_10_gdp", time_format = "num", type = "label")
bdp <- subset(bdp, time > 2006)
bdp <- subset(bdp, na_item == "Gross domestic product at market prices")
bdp <- subset(bdp, unit == "Current prices, million euro")
bdp$geo <- gsub("Euro.*", "", bdp$geo)
bdp <- subset(bdp, geo != "")
bdp <- bdp[-c(1, 2)]
names(bdp) <- (c("DRZAVA", "LETO", "GDP V MILIJONIH EVROV"))

tabela2 <- inner_join(prebivalci, bdp)
tabela2$"GDP NA PREBIVALCA V EVRIH" <- tabela2$"GDP V MILIJONIH EVROV" /
tabela2$"STEVILO PREBIVALCEV" * 1000000

tabela2$DRZAVA <- replace(tabela2$DRZAVA, tabela2$DRZAVA=="Germany (until 1990 former territory of the FRG)", "Germany")

DRZAVA <- c(unique(tabela2$DRZAVA))
c2 <- c("Albanija", "Avstrija", "Belgija", "Bolgarija", "Švica", "Ciper",
        "Češka", "Nemčija", "Danska", "Estonija", "Grčija", "Španija",
        "Finska", "Francija", "Hrvaška", "Madžarska", "Irska", "Islandija",
        "Italija", "Litva", "Luksemburg", "Latvija", "Črna Gora", "Makedonija",
        "Malta", "Nizozemska", "Norveška", "Poljska", "Portugalska", "Romunija",
        "Srbija", "Švedska", "Slovenija", "Slovaška", "Turčija", "Velika Britanija",
        "Kosovo", "Lihtenštajn", "Bosna in Herzegovina")
c3 <- data.frame(DRZAVA,c2)
tabela2 <- left_join(tabela2, c3)
tabela2 <- tabela2[-c(1)]
tabela2 <- tabela2[c(5,1,2,3,4)]
names(tabela2)[1] <- "DRZAVA"