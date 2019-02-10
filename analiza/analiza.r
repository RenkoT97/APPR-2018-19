library("factoextra")
library("reshape2")

podatki <- dcast(cetrtatabela, DRZAVA + LETO ~ NAMENPORABEGDP)
podatki <- subset(podatki, DRZAVA=="Slovenija"|DRZAVA=="Velika Britanija"|DRZAVA=="Luksemburg"|
                     DRZAVA=="Švedska"|DRZAVA=="Estonija"|DRZAVA=="Turčija"|DRZAVA=="Litva"|
                     DRZAVA=="Bolgarija"|DRZAVA=="Hrvaška"|DRZAVA=="Nemčija"|DRZAVA=="Španija"|
                     DRZAVA=="Francija"|DRZAVA=="Romunija"|DRZAVA=="Nizozemska"|DRZAVA=="Italija")
rownames(podatki) <- paste(podatki$DRZAVA, podatki$LETO, sep =", ")
podatki <- na.omit(podatki)[-c(1,2)]
podatki$`DELEŽ BDP, NAMENJEN VAROVANJU OKOLJA` <- podatki$`DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU JAVNEGA SEKTORJA` + podatki$`DELEZ BDP, NAMENJEN VAROVANJU OKOLJA V OKVIRU INDUSTRIJE`
podatki$`DELEŽ BDP, NAMENJEN INVESTICIJAM V VAROVANJE OKOLJA` <- podatki$`DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V JAVNEM SEKTORJU` + podatki$`DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V INDUSTRIJI`
podatki <- podatki[-c(1,2,3,4)]

fviz_nbclust(podatki, kmeans, method = "gap_stat")
neki <- kmeans(podatki, 3)
graf4 <- fviz_cluster(neki, data = podatki, main = "DELEŽ GDP, NAMENJEN VAROVANJU OKOLJA IN INVESTICIJAM VANJ",
             ellipse.type = "convex",
             ggtheme = theme_minimal())

tabela <- na.omit(tabela1)
graf5 <- ggplot(tabela) + aes(x=LETO, y=`EMISIJE TOPLOGREDNIH PLINOV V TONAH`) + geom_point() + geom_smooth(method = "lm")