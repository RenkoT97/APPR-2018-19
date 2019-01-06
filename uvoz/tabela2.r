library(eurostat)
library(dplyr)

prebivalci <- get_eurostat('demo_pjan', time_format = "num", type = "label")
prebivalci <- subset(prebivalci, time > 2006)
prebivalci <- subset(prebivalci, sex == 'Total')
prebivalci <- subset(prebivalci, age == 'Total')
prebivalci <- prebivalci[,-c(1,2,3)]
names(prebivalci) <- (c("DRŽAVA", "LETO", "ŠTEVILO PREBIVALCEV"))

bdp <- get_eurostat("nama_10_gdp", time_format = "num", type = "label")
bdp <- subset(bdp, time > 2006)
bdp <- subset(bdp, na_item == "Gross domestic product at market prices")
bdp <- subset(bdp, unit == "Current prices, million euro")
bdp$geo <- gsub("Euro.*", "", bdp$geo)
bdp <- subset(bdp, geo != "")
bdp <- bdp[-c(1, 2)]
names(bdp) <- (c("DRŽAVA", "LETO", "GDP V MILIJONIH EVROV"))

tabela2 <- inner_join(prebivalci, bdp)
tabela2$"GDP NA PREBIVALCA V EVRIH" <- tabela2$"GDP V MILIJONIH EVROV" /
tabela2$"ŠTEVILO PREBIVALCEV" * 1000000

write.csv(tabela2, file = "gdp.csv")