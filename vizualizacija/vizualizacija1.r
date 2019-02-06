library("sp")
library("rgdal")
library("rgeos")
library("mosaic")
library("maptools")
library("dplyr")
library("ggplot2")
library("munsell")
library("reshape2")

source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")

draw <- function(tab) {
  graf1 <<- graf1 + geom_line(aes(x=tab$LETO, y=tab$"EMISIJE TOPLOGREDNIH PLINOV V TONAH", color=tab$DRZAVA))
  return(tab)
}

draw2 <- function(tab) {
  graf3 <<- graf3 + geom_line(aes(x=tab$LETO, y=tab$INVESTICIJE, color=tab$DRZAVA))
  return(tab)
}

a <- inner_join(tabela1, tabela2)
a <- a[-c(3, 4, 5)]
a$"EMISIJE TOPLOGREDNIH PLINOV V TONAH NA PREBIVALCA" <- a$"EMISIJE TOPLOGREDNIH PLINOV V TONAH" / a$"STEVILO PREBIVALCEV"

b <- a[-c(3, 4, 5, 6)] %>% filter(LETO=="2013")
#To leto je izbrano, ker v njem ni manjkajoCih podatkov
b <- b[-c(1)]
names(b) <- c("DRZ1", "EMISIJE")

tabela4$INVESTICIJE <- tabela4$"DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V JAVNEM SEKTORJU" + tabela4$"DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V INDUSTRIJI"

Slov <- filter(tabela4, DRZAVA=="Slovenija")

zemljevid <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries") %>%
  fortify()

Evropa <- filter(zemljevid, CONTINENT == "Europe" |NAME == "Turkey")
Evropa <- filter(Evropa, long < 55 & long > -45 & lat > 30 & lat < 85)
SOVEREIGNT <- unique(Evropa$SOVEREIGNT)
DRZ1 <- c("Črna Gora", "Moldavija", "Monako", "Malta", "Makedonija", "Luksemburg",
          "Litva", "Lihtenštajn", "Latvija", "Kosovo", "Italija", "Irska", "Islandija",
          "Madžarska", "Grčija", "Nemčija", "Francija", "Finska", "Estonija", "Danska",
          "Češka", "Hrvaška", "Bolgarija", "Bosna in Herzegovina", "Belgija", "Belorusija",
          "Avstrija", "Andora", "Albanija", "Velika Britanija", "Ukrajina", "Turčija",
          "Švica", "Švedska", "Vatikan", "Španija", "Slovaška", "Slovenija", "Srbija",
          "San Marino", "Rusija", "Romunija", "Portugalska", "Poljska", "Norveška", "Nizozemska")
DRZ2 <- data.frame(SOVEREIGNT, DRZ1)
Evropa <- left_join(Evropa, DRZ2)

podatki_tortni <- filter(tabela3, LETO =="2013")
vrstica1 <- c(DRZAVA="Francija", LETO="2013", "DAVKI NA ENERGIJO V MILIJONIH EVROV"=NA, 
              "DAVKI NA ONESNAZEVANJE V MILIJONIH EVROV"=NA, "DAVKI NA RABO NARAVNIH VIROV V MILIJONIH EVROV"=NA,
              "DAVKI NA PROMET V MILIJONIH EVROV"=NA, "OKOLJSKI DAVKI V MILIJONIH EVROV"="5859.00")
število = as.numeric(podatki_tortni[3,7]) + as.numeric(podatki_tortni[4,7]) + as.numeric(podatki_tortni[24,7]) +
  as.numeric(podatki_tortni[21,7]) + as.numeric(podatki_tortni[18,7]) + as.numeric(podatki_tortni[15,7]) +
  as.numeric(podatki_tortni[17,7])
vrstica2 <- c(DRZAVA="Drugo", LETO="2013", "DAVKI NA ENERGIJO V MILIJONIH EVROV"=NA, 
             "DAVKI NA ONESNAZEVANJE V MILIJONIH EVROV"=NA, "DAVKI NA RABO NARAVNIH VIROV V MILIJONIH EVROV"=NA,
             "DAVKI NA PROMET V MILIJONIH EVROV"=NA, "OKOLJSKI DAVKI V MILIJONIH EVROV"=število)
podatki_tortni <- rbind(podatki_tortni, vrstica1)
podatki_tortni <- rbind(podatki_tortni, vrstica2)
podatki_tortni <- podatki_tortni[-c(3,4,24,21,18,15,17),]
names(podatki_tortni)[1] <- "Drzave"

graf1 <- ggplot(data.frame()) + aes(x=LETO, y=EMISIJE, color="Države")

tabgraf1 <- subset(tabela1, DRZAVA=="Slovenija"|DRZAVA=="Velika Britanija"|DRZAVA=="Luksemburg"|
                     DRZAVA=="Švedska"|DRZAVA=="Estonija"|DRZAVA=="Turčija"|DRZAVA=="Litva"|
                     DRZAVA=="Bolgarija"|DRZAVA=="Hrvaška"|DRZAVA=="Nemčija"|DRZAVA=="Španija"|
                   DRZAVA=="Francija")
tabgraf1[c(6)] <- tabgraf1[c(6)] / 1000000
tabgraf1 %>% group_by(DRZAVA) %>% do(draw(.))

graf1 <- graf1 + ggtitle("EMISIJE TOPLOGREDNIH PLINOV") + ylab("EMISIJE (V MILIJONIH TON)") +
  xlab("LETO")

graf2 <- ggplot(data.frame()) +aes(x=a$"GDP NA PREBIVALCA V EVRIH", y=a$"EMISIJE TOPLOGREDNIH PLINOV V TONAH NA PREBIVALCA") + geom_point()
graf2 <- graf2 + xlab("GDP per capita") + ylab("LETNE EMISIJE V TONAH NA PREBIVALCA") + ggtitle("VPLIV GDP NA EMISIJE TOPLOGREDNIH PLINOV") +
  geom_smooth(method = "lm")

graf3 <- ggplot(data.frame()) + aes(x=Slov$LETO, y=Slov$INVESTICIJE, color = "Države")

tabgraf3 <- subset(tabela4, DRZAVA=="Slovenija"|DRZAVA=="Velika Britanija"|DRZAVA=="Luksemburg"|
                     DRZAVA=="Švedska"|DRZAVA=="Estonija"|DRZAVA=="Turčija"|DRZAVA=="Litva"|
                     DRZAVA=="Bolgarija"|DRZAVA=="Hrvaška"|DRZAVA=="Nemčija"|DRZAVA=="Španija"|
                     DRZAVA=="Francija")
tabgraf3 %>% group_by(DRZAVA) %>% do(draw2(.))

graf3 <- graf3 + xlab("LETO") + ylab("ODSTOTEK GDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA") + ggtitle("INVESTICIJE")

ggplot(Evropa, aes(x=long, y=lat, group=group, fill=NAME)) + 
  geom_polygon() + 
  labs(title="Evropa") +
  theme(legend.position="none")

map <- ggplot() + geom_polygon(data=left_join(Evropa, b), aes(x=long, y=lat, group=group, fill=EMISIJE))
map <- map + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank())
map <- map + ggtitle("LETNE EMISIJE TOPLOGREDNIH PLINOV V TONAH NA PREBIVALCA")

priprava_tortni <- ggplot(podatki_tortni, aes(x="", y=podatki_tortni$"OKOLJSKI DAVKI V MILIJONIH EVROV", fill=Drzave))+
  geom_bar(width = 1, stat = "identity")

tortni_diagram <- priprava_tortni + coord_polar("y", start=0) +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
  axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
  ggtitle("DELEŽ POBRANIH OKOLJSKIH DAVKOV PO DRŽAVAH")

tabela4 <- tabela4[-c(7)]
