library("sp")
library("rgdal")
library("rgeos")
library("mosaic")
library("maptools")
library("dplyr")
library("ggplot2")
library("munsell")
library("reshape2")

source("uvoz/tabela1.r", encoding="UTF-8")
source("uvoz/tabela2.r", encoding="UTF-8")
source("uvoz/tabela3.r", encoding="UTF-8")
source("uvoz/tabela4.r", encoding="UTF-8")
source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")

draw <- function(tab) {
  graf1 <<- graf1 + geom_line(aes(x=LETO, y=tab$"EMISIJE TOPLOGREDNIH PLINOV V TONAH", color=tab$DRZAVA))
  return(tab)
}

draw2 <- function(tab) {
  graf3 <<- graf3 + geom_line(aes(x=tab$LETO, y=tab$INVESTICIJE, color=tab$DRZAVA))
  return(tab)
}

slo <- filter(tabela1, DRZAVA=="Slovenia")
LETO <- slo$LETO
EMISIJE <- slo$"EMISIJE TOPLOGREDNIH PLINOV V TONAH"

a <- inner_join(tabela1, tabela2)
a <- a[-c(3, 4, 5)]
a$"EMISIJE TOPLOGREDNIH PLINOV V TONAH NA PREBIVALCA" <- a$"EMISIJE TOPLOGREDNIH PLINOV V TONAH" / a$"STEVILO PREBIVALCEV"

b <- a[-c(3, 4, 5, 6)] %>% filter(LETO=="2013")
#To leto je izbrano, ker v njem ni manjkajoCih podatkov
b <- b[-c(1)]
names(b) <- c("SOVEREIGNT", "EMISIJE")

tabela4$INVESTICIJE <- tabela4$"DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V JAVNEM SEKTORJU" + tabela4$"DELEZ BDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA, PORABLJENIM V INDUSTRIJI"

Slov <- filter(tabela4, DRZAVA=="Slovenia")

zemljevid <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries") %>%
  fortify()

Evropa <- filter(zemljevid, CONTINENT == "Europe" |NAME == "Turkey")
Evropa <- filter(Evropa, long < 55 & long > -45 & lat > 30 & lat < 85)

podatki_tortni <- filter(tabela3, LETO =="2013")
vrstica <- c(DRZAVA="France", LETO="2013", "DAVKI NA ENERGIJO V MILIJONIH EVROV"=NA, 
                      "DAVKI NA ONESNAZEVANJE V MILIJONIH EVROV"=NA, "DAVKI NA RABO NARAVNIH VIROV V MILIJONIH EVROV"=NA,
                      "DAVKI NA PROMET V MILIJONIH EVROV"=NA, "OKOLJSKI DAVKI V MILIJONIH EVROV"="5859.00")
podatki_tortni <- rbind(podatki_tortni, vrstica)

graf1 <- ggplot(data.frame()) + aes(x=LETO, y=EMISIJE, color="Države")

tabela1 %>% group_by(DRZAVA) %>% do(draw(.))

graf1 <- graf1 + ggtitle("EMISIJE TOPLOGREDNIH PLINOV")

graf2 <- ggplot(data.frame()) +aes(x=a$"GDP NA PREBIVALCA V EVRIH", y=a$"EMISIJE TOPLOGREDNIH PLINOV V TONAH NA PREBIVALCA") + geom_point()
graf2 <- graf2 + xlab("GDP per habita") + ylab("LETNE EMISIJE V TONAH NA PREBIVALCA") + ggtitle("VPLIV GDP NA EMISIJE TOPLOGREDNIH PLINOV") +
  geom_smooth(method = "lm")

graf3 <- ggplot(data.frame()) + aes(x=Slov$LETO, y=Slov$INVESTICIJE, color = "Države")

tabela4 %>% group_by(DRZAVA) %>% do(draw2(.))

graf3 <- graf3 + xlab("LETO") + ylab("ODSTOTEK GDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA") + ggtitle("INVESTICIJE")

ggplot(Evropa, aes(x=long, y=lat, group=group, fill=NAME)) + 
  geom_polygon() + 
  labs(title="Evropa") +
  theme(legend.position="none")

map <- ggplot() + geom_polygon(data=left_join(Evropa, b), aes(x=long, y=lat, group=group, fill=EMISIJE))
map <- map + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank())
map <- map + ggtitle("LETNE EMISIJE TOPLOGREDNIH PLINOV V TONAH NA PREBIVALCA")

priprava_tortni <- ggplot(podatki_tortni, aes(x="", y=podatki_tortni$"OKOLJSKI DAVKI V MILIJONIH EVROV", fill=DRZAVA))+
  geom_bar(width = 1, stat = "identity")

tortni_diagram <- priprava_tortni + coord_polar("y", start=0) +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
  axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
  ggtitle("DELEŽ POBRANIH OKOLJSKIH DAVKOV PO DRŽAVAH")

