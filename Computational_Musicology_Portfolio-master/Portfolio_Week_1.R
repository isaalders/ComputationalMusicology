# Portfolio Week 1

library(tidyverse)
library(spotifyr)

# Set Spotify access variables (every time)

Sys.setenv(SPOTIFY_CLIENT_ID = '6e4882dc71024995bb09cfb197afd81c')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '4293a63fc81a4d40ac9edf9601e9c99d')

# My Spotify Favorites
favorites=get_playlist_audio_features("Tosca Beijaert","16OAuKPZYr8YM4a9n1V6kf")
View(favorites)
favorites1=data.frame(favorites[c(6:21,31,37)]) # Creates dataframe for only important columns

# Alex favorites 
alex=get_playlist_audio_features("Alexander Keijser","59c8tug3WdwODj6gV0ierq")
View(alex)
alex1=data.frame(alex[c(6:21,31,37)]) 

# Discover weekly Favorites week 1
discover_weekly1=get_playlist_audio_features("Tosca Beijaert","1RGiBzoNLHf0GkTYRxDhpY")
View(discover_weekly1)
discover_weekly1.1=data.frame(discover_weekly1[c(6:21,31,37)])

# The DANCIBILITY
favorites %>% summarise(M=mean(danceability, na.rm = T), SD=sd(danceability, na.rm = T)) 
# There are some NA's, thus we exclude those. Those might be songs added to spotify manually from
# files of my computer?
discover_weekly1 %>%  summarise(M=mean(danceability),SD=sd(danceability))
alex %>%  summarise(M=mean(danceability),SD=sd(danceability))


# THE ENERGY
favorites %>% summarise(M=mean(energy, na.rm = T), SD=sd(energy, na.rm = T)) 
discover_weekly1 %>%  summarise(M=mean(energy),SD=sd(energy))
alex %>%  summarise(M=mean(energy),SD=sd(energy))


# THE INSTRUMENTALNESS
favorites %>% summarise(M=mean(instrumentalness, na.rm = T), SD=sd(instrumentalness, na.rm = T)) 
discover_weekly1 %>%  summarise(M=mean(instrumentalness),SD=sd(instrumentalness))
alex %>%  summarise(M=mean(instrumentalness),SD=sd(instrumentalness))

# THE TEMPO
favorites %>% summarise(M=mean(tempo, na.rm = T), SD=sd(tempo, na.rm = T)) 
discover_weekly1 %>%  summarise(M=mean(tempo),SD=sd(tempo))
alex %>%  summarise(M=mean(tempo),SD=sd(tempo))
# We can see big differences in the means of danceability.

# Popularity
favorites %>% summarise(M=mean(track.popularity, na.rm = T), SD=sd(track.popularity, na.rm = T)) 
discover_weekly1 %>%  summarise(M=mean(track.popularity),SD=sd(track.popularity))
alex %>%  summarise(M=mean(track.popularity),SD=sd(track.popularity))


favorites %>% summarise(M=mean(speechiness, na.rm = T), SD=sd(speechiness, na.rm = T)) 
discover_weekly1 %>%  summarise(M=mean(speechiness),SD=sd(speechiness))
alex %>%  summarise(M=mean(speechiness),SD=sd(speechiness))

# Some plots of the data. OUtliers don't really matter for My favourites and Alex's favourites as they 
# contain a lot of songs

plot(favorites$energy)
hist(favorites$instrumentalness)
hist(alex$energy)
hist(alex$instrumentalness)

# However for discover weakly it does matter.
par(mfrow=c(2,2))
plot(discover_weekly1$danceability)
plot(discover_weekly1$energy)
plot(discover_weekly1$instrumentalness)
plot(discover_weekly1$tempo)




# A way to fint the maxmax outliers or min outliers
which.max(alex$energy)  
favorites$energy[838]
favorites$track.name[838]

which.min(favorites$danceability)
favorites$track.name[4705]

which.max(favorites$danceability)
favorites$track.name[4441]


favorites$danceability[favorites$track.name=="Bring"] # Meest danceable tune

which.max(favorieten$liveness)



discover_weekly1 %>%  summarise(M=mean(loudness),SD=sd(loudness))
alex %>%  summarise(M=mean(loudness),SD=sd(loudness))
hist(alex$loudness)
hist(discover_weekly1$loudness)

discover_weekly1 %>%  summarise(M=mean(acousticness),SD=sd(acousticness))
alex %>%  summarise(M=mean(acousticness),SD=sd(acousticness))
hist(alex$acousticness)
hist(discover_weekly1$acousticness)
