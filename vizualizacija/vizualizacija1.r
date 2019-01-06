library("sp")
library("rgdal")
library("rgeos")
library("mosaic")
library("maptools")
library("dplyr")
library("ggplot2")


source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")

europe <- uvozi.zemljevid("https://mapcruzin.com/download-shapefile/europe-natural-shape.zip",
                          "natural", encoding="Windows-1250") %>% fortify()

ggplot(europe, aes(x=long, y=lat, group=group)) +   
  geom_polygon() + 
  labs(title="Evropa - osnovna slika") +
  theme(legend.position="none")

emisije <- read.csv("emisije.csv")
emisije <- emisije[-c(1)]
names(emisije) <- (c("LETO", "DRŽAVA", "EMISIJE OGLJIKOVEGA DIOKSIDA V TONAH", "EMISIJE METANA V TONAH",
                        "EMISIJE DUŠIKOVEGA OKSIDA V TONAH", "EMISIJE TOPLOGREDNIH PLINOV V TONAH"))

slo <- filter(emisije, DRŽAVA=="Slovenia")
LETO <- slo$LETO
EMISIJE <- slo[,c(6)]
graf <- ggplot(data.frame()) + aes(x=LETO, y=EMISIJE, color = "Države") + geom_line()

draw <- function(tab) {
  graf <<- graf + geom_line(aes(x=LETO, y=tab$"EMISIJE TOPLOGREDNIH PLINOV V TONAH", color=tab$DRŽAVA))
  return(tab)
}

emisije %>% group_by(DRŽAVA) %>% do(draw(.))

graf <- graf + scale_linetype_discrete(name = "Države")
graf <- graf + ggtitle("EMISIJE TOPLOGREDNIH PLINOV")
print(graf)
