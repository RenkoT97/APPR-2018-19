library(readr)
library(reshape2)
library(dplyr)

emisijeCO2 <- read_csv("emisijeCO2.csv", na = c(":"))
emisijeCO2 <- emisijeCO2[-c(1:10),]
emisijeCO2 <- emisijeCO2[,-c(3,4,5,7)]
names(emisijeCO2) <- (c("LETO", "DRŽAVA", "EMISIJE OGLJIKOVEGA DIOKSIDA V TONAH"))

emisijeCH4 <- read_csv("emisijeCH4.csv", na = c(":"))
emisijeCH4 <- emisijeCH4[-c(1:10),]
emisijeCH4 <- emisijeCH4[,-c(3,4,5,7)]
names(emisijeCH4) <- (c("LETO", "DRŽAVA", "EMISIJE METANA V TONAH"))

emisijeNO <- read_csv("emisijeNO.csv", na = c(":"))
emisijeNO <- emisijeNO[-c(1:10),]
emisijeNO <- emisijeNO[,-c(3,4,5,7)]
names(emisijeNO) <- (c("LETO", "DRŽAVA", "EMISIJE DUŠIKOVEGA OKSIDA V TONAH"))

tabela1 <- inner_join(emisijeCO2, emisijeCH4)
tabela1 <- inner_join(tabela1, emisijeNO)
tabela1$"EMISIJE TOPLOGREDNIH PLINOV V TONAH" <- tabela1$"EMISIJE OGLJIKOVEGA DIOKSIDA V TONAH" +
tabela1$"EMISIJE METANA V TONAH" + tabela1$"EMISIJE DUŠIKOVEGA OKSIDA V TONAH"

write.csv(tabela1, file = "emisije.csv")

