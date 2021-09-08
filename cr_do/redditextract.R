library(RedditExtractoR)
library(tidyverse)
top_cats_urls <- find_thread_urls(subreddit="singapore",
                                  keywords=c("robot"),
                                  period = "year")


# Robots to patrol Toa Payoh Central for 3 weeks to detect 'undesirable social behaviour'
# Autonomous robots check on bad behaviour in Singapore's heartland
# HTX Ground Robot On Trial At Toa Payoh Central To Support Public Officers In Enhancing Public Health And Safety

top_cats_urls <- 
    top_cats_urls %>% 
    filter(title == "Robots to patrol Toa Payoh Central for 3 weeks to detect 'undesirable social behaviour'" |
           title == "Autonomous robots check on bad behaviour in Singapore's heartland" |
           title == "HTX Ground Robot On Trial At Toa Payoh Central To Support Public Officers In Enhancing Public Health And Safety")


#top_cats_urls <- find_thread_urls(subreddit="singapore",
#                                  keywords=c("spank"),
#                                  period = "all")

threads_contents <- get_thread_content(top_cats_urls$url[1:3])
str(threads_contents$threads)
str(threads_contents$comments)

first <- threads_contents$threads
second <- threads_contents$comments
getwd()

save(second, file = "datafiles/reddit.RData")

rm(list = ls())
load("datafiles/reddit.RData")
ai <- second
rm(second)

# Section A) Convert to Corpus and DFM ####

## Convert to corpus ==== 
library(quanteda)

ai <-
    ai %>% 
    mutate(id = row_number()) %>% 
    relocate(id, .before = url) 
    
                                  
ai_corp <- corpus(ai,
                  docid_field = "id",
                  text_field = "comment")
                      
                      
## Convert to tokens -> then DFM ==== 
ai_tok <- 
    tokens(ai_corp, 
           remove_numbers = T,
           remove_punct = T,
           remove_symbols = T,
           include_docvars = T, 
           remove_separators = T
    ) 


mystopwords <- c("toa", "payoh", "AI", "robot", "robots", "xavier")


ai_dfm <- 
    dfm(ai_tok,
        tolower = T) %>% 
    dfm_remove(
        c(phrase(mystopwords), stopwords("en"))) %>% 
    dfm_wordstem() 

# Section B) Word Clouds ####
library("quanteda.textplots")
set.seed(100)
#textplot_wordcloud(news_dfm)

textplot_wordcloud(ai_dfm, 
                   max_words = 100, 
                   min_count = 10,
                   random_order = F, 
                   #  rotation = 0.25, 
                   color = RColorBrewer::brewer.pal(8, "Dark2"))  #

set.seed(100)
textplot_wordcloud(ai_dfm, color = c("#459DE0", "#F53446"), max_words = 100,
                   min_count = 15, random_order = F ) 



top_cats_urls <- find_thread_urls(subreddit="singapore",
                                  keywords=c("caning"),
                                  period = "all")

top_cats_urls <- find_thread_urls(subreddit="singapore",
                                  keywords=c("spank"),
                                  period = "all")

threads_contents <- get_thread_content(top_cats_urls$url[2])
str(threads_contents$threads)
str(threads_contents$comments)

library(tidyverse)
first <- threads_contents$threads
second <- threads_contents$comments

combined <- 
    first %>% 
    inner_join(second)
