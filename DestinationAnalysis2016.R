# Destination Data

library(ggplot2)
library(dplyr)
library(wordcloud)
library(tm)
library(SnowballC)
library(RColorBrewer)
library(tidyr)

pal <- brewer.pal(9,"BuGn")
pal <- pal[-(1:4)]

d1<-read.csv('~/GitHubRepos/AdmissionsAPS/Destinations1.csv')

head(d1)
d1<-select(d1, Employer, Job.title)

jobCorpus<-Corpus(VectorSource(as.character(d1$Job.title)))
jobCorpus <- tm_map(jobCorpus, tolower)

jobCorpus <- tm_map(jobCorpus, removeWords, stopwords("english"))
jobCorpus <- tm_map(jobCorpus, removeWords, c('assistant','intern'))

jobCorpus <- tm_map(jobCorpus, PlainTextDocument)

set.seed(123)
wordcloud(jobCorpus, max.words = 100, random.order = FALSE, rot.per = 0.2, col = pal)

# --------------
d2<-read.csv('~/GitHubRepos/AdmissionsAPS/Destinations2.csv')
head(d2)
d2 <- d2 %>%
	slice(-1) %>%
	select(c(1,3,5,7,9)) %>%
	gather(Year, Percentage, -X)

d2 %>% group_by(Year) %>% summarise(n())

d2<- d2 %>%
	mutate(Year = rep(2012:2015, each = 123)) %>%
	filter(Percentage >1.0)

Education<-filter(d2, grepl("education", X))
NotEducation<-filter(d2, !grepl("education", X))

