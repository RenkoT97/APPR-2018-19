# Analiza podatkov s programom R, 2018/19

#Tjaša Renko

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/RenkoT97/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/RenkoT97/APPR-2018-19/master?urlpath=rstudio) RStudio

## Analiza izpustov toplogrednih plinov v ozračje po Evropi

Toplogredni plini so plini, ki povzročajo učinek tople grede in s tem pripomorejo k globalnemu segrevanju ozračja. V nalogi se bom osredotočila na primerjavo količine izpustov le-teh v zrak z okoljskimi ukrepi po evropskih državah. 

Podatke o letnih izpustih treh toplogrednih plinov (CO2, NO in CH4) v ozračje v evropskih državah od leta 2007 do 2016 bom gledala v razmerju s številom prebivalcev, da bodo podatki primerljivi. To bom primerjala s količino denarja, ki ga država vlaga v okolje ter v posamezne panoge, pri katerih prihaja do nastanka topogrednih plinov, in poskusila sklepati, kateri ukrepi so najbolj učinkoviti. Podrobneje bom gledala emisije iz odpadkov, kmetijstva in prometa.

Viri:

* [Izpusti ogljikovega dioksida v ozračje](http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=env_ac_ainah_r2&lang=en)
* [Izpusti metana v ozračje](http://appsso.eurostat.ec.europa.eu/nui/submitViewTableAction.do)
* [Izpusti dušikovega oksida](http://appsso.eurostat.ec.europa.eu/nui/submitViewTableAction.do)
* [Izpusti toplogrednih plinov zaradi kmetijstva](https://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&language=en&pcode=tai08&plugin=1)
* [Izpusti toplogrednih plinov zaradi prometa](https://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&language=en&pcode=t2020_rk300&plugin=1)
* [Izdatki za okoljsko varstvo](https://ec.europa.eu/eurostat/tgm/refreshTableAction.do?tab=table&plugin=1&pcode=ten00049&language=en)
* [Kapacitete pri proizvodnji biogoriv](http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=nrg_114a&lang=en)
* [Okoljski davki](http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=env_ac_taxind2&lang=en)

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem.zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
