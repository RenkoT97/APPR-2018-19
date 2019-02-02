library(readr)
library(reshape2)
library(dplyr)
library(eurostat)

emisijeCO2 <- read_csv("podatki/emisijeCO2.csv", na=c(":"))
emisijeCO2 <- emisijeCO2[-c(1:10),]
emisijeCO2 <- emisijeCO2[,-c(3,4,5,7)]
names(emisijeCO2) <- (c("LETO", "DRZAVA", "EMISIJE OGLJIKOVEGA DIOKSIDA V TONAH"))

emisijeCH4 <- read_csv("podatki/emisijeCH4.csv", na = c(":"))
emisijeCH4 <- emisijeCH4[-c(1:10),]
emisijeCH4 <- emisijeCH4[,-c(3,4,5,7)]
names(emisijeCH4) <- (c("LETO", "DRZAVA", "EMISIJE METANA V TONAH"))

emisijeNO <- read_csv("podatki/emisijeNO.csv", na = c(":"))
emisijeNO <- emisijeNO[-c(1:10),]
emisijeNO <- emisijeNO[,-c(3,4,5,7)]
names(emisijeNO) <- (c("LETO", "DRZAVA", "EMISIJE DUSIKOVEGA OKSIDA V TONAH"))

tabela1 <- inner_join(emisijeCO2, emisijeCH4)
tabela1 <- inner_join(tabela1, emisijeNO)
tabela1$"EMISIJE TOPLOGREDNIH PLINOV V TONAH" <- tabela1$"EMISIJE OGLJIKOVEGA DIOKSIDA V TONAH" +
tabela1$"EMISIJE METANA V TONAH" + tabela1$"EMISIJE DUSIKOVEGA OKSIDA V TONAH"

tabela1[41:50, "DRZAVA"] <- "Germany"

DRZAVA <- c(unique(tabela1$DRZAVA))
c2 <- c("Belgija", "Bolgarija", "Češka", "Danska", "Nemčija", "Estonija",
            "Irska", "Grčija", "Španija", "Francija", "Hrvška", "Italija",
            "Ciper", "Latvija", "Litva", "Luksemburg", "Madžarska", "Malta",
            "Nizozemska", "Avstrija", "Poljska", "Portugalska", "Romunija",
            "Slovenija", "Slovaška", "Finska", "Švedska", "Velika Britanija",
            "Norveška", "Švica", "Srbija", "Turčija")
c3 <- data.frame(DRZAVA,c2)
tabela1 <- left_join(tabela1, c3)
tabela1 <- tabela1[-c(2)]
tabela1 <- tabela1[c(1,6,2,3,4,5)]
names(tabela1)[2] <- "DRZAVA"
