library(twitteR)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(tidytext)

#importing API, key information
appname <- "Misinformation-News"
key <- "RF78rAZA1bOvrMFIzw1blX2Mm"
secret <- "4vhyPeO8IS8Isaj3c6JYWlKj7ZndlpuMsfHE4XHnIRaEm7cjFd"
access_token <- "2601140743-LqYRNxAxbfWBTa5ACWzZfnf7cJbmpkvuZwe2jr6"
access_secret <- "5Zuwpe1VHuLa2506iG1hqoovf9JbyFzIl2z2JhmIwfai8"
setup_twitter_oauth(key, secret, access_token, access_secret)

#Browsing twitter to find common keywords connected to the recent Wayfair human trafficking rumor
fn_twitter <- searchTwitter("trafficking", since = "2020-07-07", until = "2020-07-14", n=500,lang="en")
fn_twitter_df <- twListToDF(fn_twitter)

tweet_words <- fn_twitter_df %>% select(id, text) %>% unnest_tokens(word,text)

tweet_words %>% count(word,sort=T) %>% slice(1:20) %>% 
  ggplot(aes(x = reorder(word, n, function(n) -n), y = n)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab('Common Keywords') + ylab('Number of occurences') + ggtitle('Common Misinformation Keywords- 07/07-07/14') %>% print()

#making vector of words that are not relevant
my_stop_words <- stop_words %>% select(-lexicon) %>% 
  bind_rows(data.frame(word = c("rt","the","to","and","https","in","is","his","for","of","i","this","out","are","a","they","just","know","have","has","all","such","on","seems","when")))

tweet_words_interesting <- tweet_words %>% anti_join(my_stop_words)

tweet_words_interesting %>% group_by(word) %>% tally(sort=TRUE) %>% slice(1:25) %>% ggplot(aes(x = reorder(word, n, function(n) -n), y = n)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60,hjust = 1)) + xlab('Common Keywords') + ylab('Number of occurences') + ggtitle('Common Misinformation Keywords- 07/07-07/14') %>% print() 

#"child" was also a top keyword in connection to the rumor. Below I create a csv file of the most popular posts in connection to the rumor.
fn_twitter.wayfair <- searchTwitter("child", since = "2020-07-07", until = "2020-07-14", n=100, resultType = "popular", lang="en")
fn_twitter_df.wayfair <- twListToDF(fn_twitter)

fn_twitter_df.wayfair <- fn_twitter_df.wayfair[order(-fn_twitter_df$favoriteCount),]
print(head(fn_twitter_df.wayfair))
write.csv(fn_twitter_df.wayfair,"Wayfair.csv", row.names = FALSE)