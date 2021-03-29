# Portfolio Week 2
library(tidyverse)
library(spotifyr)

# Set Spotify access variables (every time)
Sys.setenv(SPOTIFY_CLIENT_ID = '6e4882dc71024995bb09cfb197afd81c')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '4293a63fc81a4d40ac9edf9601e9c99d')

# My Spotify Favorites
favorites=get_playlist_audio_features("Tosca Beijaert","16OAuKPZYr8YM4a9n1V6kf")

# Because there were local files in the list, spotify added extra columns, which i removed as the other
# playlists don't have these comments, so it will be useless for compariosn.
favorites=favorites[-c(59:63)]

# We also have to remove the local files, as i cannot  compare them as there is no analysis for these tracks.
favorites=subset(favorites, track.is_local==FALSE) # we delete the local files
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

# Discover weekly favorites week 2

discover_weekly2=get_playlist_audio_features("Tosca Beijaert", "24kpxnb8oyQykp71Gn3sge")
View(discover_weekly2)
discover_weekly2.1=data.frame(discover_weekly2[c(6:21,31,37)])

# Discover weekly 1 & 2 combined (combined playlists)

discover_weekly_combined_week2=merge(discover_weekly1[6:16],discover_weekly2.1[6:16])
View(discover_weekly_combined_week2) # WHY DOES THIS NOT WORK???A


# Discover Weekly Archive

discover_weekly_archive=get_playlist_audio_features("Tosca Beijaert", "4jLB65Tpbt91Ta2QrypTFV")
View(discover_weekly_archive)
discover_weekly_archive_small=data.frame(discover_weekly2[c(6:21,31,37)])



# MAKING PLOTS.

# We will now start making plots. We want 1 plot that compares the 3 playlists & 1 plot that compares the
# discover weekly playlists over time.

# Comparing the 3 playlists.
# we combine the 3 data sets favorites, alex and discover weekly archive.

playlists=
  alex %>% mutate(playlist = "Alex") %>%
  bind_rows(favorites %>% mutate(playlist = "Favorites")) %>%
  bind_rows(discover_weekly1%>% mutate(playlist = "Discover Weekly Base")) 


# 1. We start with the baseline differences for alex's favourties, my faovrites and discover weekly week 1.

playlists %>%
  ggplot(aes(x = energy, col=playlist)) +
  geom_histogram() +
  facet_wrap(~ playlist, scales="free_y")+
  scale_x_continuous(
    limits=c(0,1),
    breaks=c(0,0.5,1)
  )+
  labs(color='Playlist', title='Energy per Playlist') +
  xlab('Energy') +
  ylab("Count")+
  theme_get()

playlists %>%
  ggplot(aes(x = tempo,  col=playlist)) +
  geom_histogram() +
  facet_wrap(~ playlist, scales="free_y")+
  scale_x_continuous(
    limits=c(0,250),
    breaks=c(0,125,250)
  )+
  labs(color='Playlist', title='Tempo per Playlist') +
  xlab('Tempo')+
  ylab("Count")+
  theme_get()

playlists %>%
  ggplot(aes(x = danceability, col=playlist)) +
  geom_histogram() +
  facet_wrap(~ playlist, scales="free_y")+
  scale_x_continuous(
    limits=c(0,1),
    breaks=c(0,0.5,1)
  )+
  labs(color='Playlist', title='Danceability per Playlist') +
  xlab('Danceability') +
  ylab("Count")+
  theme_get()

playlists %>%
  ggplot(aes(x = instrumentalness, col=playlist)) +
  geom_histogram() +
  facet_wrap(~ playlist, scales="free_y")+
  scale_x_continuous(
    limits=c(0,1),
    breaks=c(0,0.5,1)
  )+
  labs(color='Playlist', title='Instrumentalness per Playlist') +
  xlab('Instumentalness') +
  ylab("Count")+
  theme_get()

# Start with faceting or boxplot/violin to split by group.


# Showing dancibility and energy at a plot per playlist.
ggplot(playlists_sample, aes(danceability, energy, col=playlist))+
  geom_jitter(alpha=0.5)+ # ADJUST SHAPE
  geom_smooth() # Onduidelijk


# Show the changes of discover weekly over time.
# First make facet for every week of discover_weekly
# Add the discover weekly for every week to these facets.

discover_weekly_progresss=
  discover_weekly1 %>% mutate(playlist = "Week 1") %>%
  bind_rows(discover_weekly2 %>% mutate(playlist = "Week 2"))

discover_weekly_progresss %>%
  ggplot(aes(x = playlist, y=danceability, col=instrumentalness)) + 
  geom_point() 
 




library(lubridate)
discover_weekly_archive$week=isoweek(discover_weekly_archive$added_at)

discover_weekly_archive=cbind(discover_weekly_archive, week)

View(discover_weekly_archive)

aggregate(x=discover_weekly_archive, by=list(discover_weekly_archive$week), FUN =mean)

# We want to do this at the end of the 8 weeks...

means_all=aggregate(x=discover_weekly_archive, by=list(discover_weekly_archive$week), FUN =mean)
danceability_mean=means_all$danceability

ggplot(discover_weekly_archive %>% summarise(danceability=mean(danceability)), aes(discover_weekly_archive$week, danceability))+
  geom_point()
  
 danceability_mean
 

  



# Start with point/jitter to compare two continuous variables.

alex %>% ggplot(aes(x = danceability, y = energy)) + geom_point() + geom_smooth()




# Comparisons for multiple features per playlist.

playlists %>%
  ggplot(aes(x = energy, y=danceability, col=instrumentalness)) + # Add tempo to size here
  geom_point() +
  geom_rug(size = 0.1)+ 
  facet_wrap(~ playlist)+
  labs(title='Energy, Danceability, Instrumentalness and Tempo per Playlist') +
  scale_x_continuous(          # Fine-tune the x axis.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),  # Use grid-lines for quadrants only.
    minor_breaks = NULL      # Remove 'minor' grid-lines.
  ) +
  scale_y_continuous(          # Fine-tune the y axis in the same way.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),
    minor_breaks = NULL
  ) +
  theme_classic() +              # Use a simpler them.
  labs(                        # Make the titles nice.
    x = "Energy",
    y = "Danceability",
    colour = "Instrumentalness",
    size="Tempo"
  )
# Its a bit hard to see whats going on for my favourites and alex's favourites,
# thus we take a sample of 500 out of those playlists to get a better view.

fav_sample=favorites[sample(nrow(favorites),500),]
alex_sample=alex[sample(nrow(alex),500),]

playlists_sample=
  alex_sample %>% mutate(playlist = "Alex Sample") %>%
  bind_rows(fav_sample %>% mutate(playlist = "Favorites Sample")) %>%
  bind_rows(discover_weekly1%>% mutate(playlist = "Discover Weekly Base")) 



playlists_sample %>%
  ggplot(aes(x = energy, y=danceability, col=instrumentalness)) + # Add tempo to size here
  geom_point() +
  geom_rug(size = 0.1)+ 
  facet_wrap(~ playlist)+
  labs(title='Energy, Danceability, Instrumentalness and Tempo per Playlist') +
  scale_x_continuous(          # Fine-tune the x axis.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),  # Use grid-lines for quadrants only.
    minor_breaks = NULL      # Remove 'minor' grid-lines.
  ) +
  scale_y_continuous(          # Fine-tune the y axis in the same way.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),
    minor_breaks = NULL
  ) +
  theme_classic() +              # Use a simpler them.
  labs(                        # Make the titles nice.
    x = "Energy",
    y = "Danceability",
    colour = "Instrumentalness",
    size="Tempo"
  )
