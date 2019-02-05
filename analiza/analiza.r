library("factoextra")

podatki <- na.omit(tabela4)
podatki$"DELEŽ GDP" <- podatki$`DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU JAVNEGA SEKTORJA` +
  podatki$`DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU INDUSTRIJE` +
  podatki$`DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V JAVNEM SEKTORJU` +
  podatki$`DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V INDUSTRIJI`
podatki <- na.omit(podatki)[-c(3,4,5,6)]
podatki$"DELEŽ GDP" <- 10000 * podatki$"DELEŽ GDP"
imenavrstic <- paste(podatki$DRZAVA, podatki$LETO, sep =", ")
podatki <- podatki[-c(1)]
rownames(podatki) <- imenavrstic

fviz_nbclust(podatki, kmeans, method = "gap_stat")
neki <- kmeans(podatki, 3)
graf4 <- fviz_cluster(neki, data = podatki, main = "DELEŽ GDP, NAMENJEN VAROVANJU OKOLJA IN INVESTICIJAM VANJ",
             ellipse.type = "convex",
             ggtheme = theme_minimal())

tabela <- na.omit(tabela1)
graf5 <- ggplot(tabela) + aes(x=LETO, y=`EMISIJE TOPLOGREDNIH PLINOV V TONAH`) + geom_point() + geom_smooth(method = "lm")
