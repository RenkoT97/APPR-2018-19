library("factoextra")
source("uvoz/tabela4.r", encoding="UTF-8")

podatki <- na.omit(tabela4)
podatki$"DELEŽ GDP" <- podatki$`DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU JAVNEGA SEKTORJA` +
  podatki$`DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU INDUSTRIJE` +
  podatki$`DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V JAVNEM SEKTORJU` +
  podatki$`DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V INDUSTRIJI`
podatki <- na.omit(podatki)[-c(3,4,5,6)]
podatki$"DELEŽ GDP" <- 10000 * podatki$"DELEŽ GDP"
podatki$vrstice <- paste(podatki$DRZAVA, podatki$LETO, sep =", ")
rownames(podatki) <- podatki[,4]
podatki <- podatki[-c(1,4)]

fviz_nbclust(podatki, kmeans, method = "gap_stat")
neki <- kmeans(podatki, 3)
graf4 <- fviz_cluster(neki, data = podatki, main = "DELEŽ GDP, NAMENJEN VAROVANJU OKOLJA IN INVESTICIJAM VANJ",
             ellipse.type = "convex",
             ggtheme = theme_minimal())
