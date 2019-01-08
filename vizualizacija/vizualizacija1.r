library("sp")
library("rgdal")
library("rgeos")
library("mosaic")
library("maptools")
library("dplyr")
library("ggplot2")
library("munsell")
library("reshape2")

emisije <- read.csv("emisije.csv")
emisije <- emisije[-c(1)]

gdp <- read.csv("gdp.csv")
gdp <- gdp[-c(1)]

davki <- read.csv("davki.csv")
davki <- davki[-c(1)]

vlaganja <- read.csv("vlaganja.csv")
vlaganja <- vlaganja[-c(1)]

slo <- filter(emisije, DRŽAVA=="Slovenia")
LETO <- slo$LETO
EMISIJE <- slo[,c(6)]
graf1 <- ggplot(data.frame()) + aes(x=LETO, y=EMISIJE, color = "Države") + geom_line()

draw <- function(tab) {
  graf1 <<- graf1 + geom_line(aes(x=LETO, y=tab$EMISIJE.TOPLOGREDNIH.PLINOV.V.TONAH, color=tab$DRŽAVA))
  return(tab)
}

emisije %>% group_by(DRŽAVA) %>% do(draw(.))

graf1 <- graf1 + scale_linetype_discrete(name = "Države")
graf1 <- graf1 + ggtitle("EMISIJE TOPLOGREDNIH PLINOV")
print(graf1)

a <- inner_join(emisije, gdp)
a <- a[-c(3, 4, 5)]
a$EMISIJE.TOPLOGREDNIH.PLINOV.V.TONAH.NA.PREBIVALCA <- a$EMISIJE.TOPLOGREDNIH.PLINOV.V.TONAH / a$ŠTEVILO.PREBIVALCEV

graf2 <- ggplot(data.frame()) +aes(x=a$GDP.NA.PREBIVALCA.V.EVRIH, y=a$EMISIJE.TOPLOGREDNIH.PLINOV.V.TONAH.NA.PREBIVALCA) + geom_point()
graf2 <- graf2 + xlab("GDP per habita") + ylab("LETNE EMISIJE V TONAH NA PREBIVALCA") + ggtitle("VPLIV GDP NA EMISIJE TOPLOGREDNIH PLINOV")
print(graf2)

Slo <- filter(vlaganja, DRŽAVA=="Slovenia")
graf3 <- ggplot(data.frame()) + aes(x=Slo$LETO, y=Slo$INVESTICIJE, color = "Države") + geom_line()

draw2 <- function(tab) {
  graf3 <<- graf3 + geom_line(aes(x=tab$LETO, y=tab$INVESTICIJE, color=tab$DRŽAVA))
  return(tab)
}

vlaganja$INVESTICIJE <- vlaganja$DELEŽ.BDP..NAMENJEN.INVESTICIJAM.ZA.VAROVANJE.OKOLJA..PORABLJENIM.V.JAVNEM.SEKTORJU + vlaganja$DELEŽ.BDP..NAMENJEN.INVESTICIJAM.ZA.VAROVANJE.OKOLJA..PORABLJENIM.V.INDUSTRIJI
vlaganja %>% group_by(DRŽAVA) %>% do(draw2(.))

graf3 <- graf3 + xlab("LETO") + ylab("ODSTOTEK GDP, NAMENJEN INVESTICIJAM ZA VAROVANJE OKOLJA") + ggtitle("INVESTICIJE")
print(graf3)

source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")

zemljevid <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries") %>%
  fortify()

Evropa <- filter(zemljevid, CONTINENT == "Europe" |NAME == "Turkey")
Evropa <- filter(Evropa, long < 55 & long > -45 & lat > 30 & lat < 85)

ggplot(Evropa, aes(x=long, y=lat, group=group, fill=NAME)) + 
  geom_polygon() + 
  labs(title="Evropa") +
  theme(legend.position="none")

b <- a[-c(3, 4, 5, 6)] %>% filter(LETO=="2013")
#To leto je izbrano, ker v njem ni manjkajočih podatkov
b <- b[-c(1)]
b[5, "DRŽAVA"] <- "Germany"
names(b) <- c("SOVEREIGNT", "EMISIJE")

map <- ggplot() + geom_polygon(data=left_join(Evropa, b), aes(x=long, y=lat, group=group, fill=EMISIJE))
map <- map + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank())
map <- map + ggtitle(" LETNE EMISIJE TOPLOGREDNIH PLINOV V TONAH NA PREBIVALCA")
print(map)
