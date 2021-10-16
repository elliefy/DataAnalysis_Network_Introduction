Brief Introduction - Network in online discussion forum
----------------


Preparation - Install packages
----------------
<pre class="r"><code>library(dplyr)
library(quanteda)
library(topicmodels)
library(ldatuning)
library(dplyr)
library(tidytext)
library(tidyverse)
library(ggplot2)
library(rmarkdown)</code></pre>

Pre-Process data frames
----------------
<pre class="r"><code>pkgs = c("tidyverse", "igraph", "ggraph", "tidygraph")
#load packages
ld_pkgs = lapply(pkgs, library, character.only = TRUE)</code></pre>

Identify node and edge files
----------------
<pre class="r"><code>edges0 = read.csv("demo_ntwk.csv", sep = ",", header = TRUE)
edges = edges0 %>% select(from, to)
edges1 = edges %>% count(from, to) %>% ungroup() %>%  rename(weight = n) 
nodes0 = read.csv("node_feature.csv", sep = ",", header = TRUE)</code></pre>

Create edge files
----------------
<pre class="r"><code>#all degree
temp_total = as.data.frame(table(c(as.character(edges0$to), as.character(edges0$from))))
colnames(temp_total) = c("Users","total_degree")
#in degree
temp_in = as.data.frame(table(edges0$to))
colnames(temp_in) = c("Users","in_degree")
#out degree
temp_out = as.data.frame(table(edges0$from))
colnames(temp_out) = c("Users","out_degree")
#num of initial posts per author
df_num_msg = edges0 %>% select(to, post) %>% unique() %>% count(to) %>% ungroup() %>% rename(num_initiated_post = n)</code></pre>

Run LDA topic modeling
----------------
<pre class="r"><code>k <- 20 # Number of topics
control_LDA <- list(alpha = 50/k, estimate.beta = TRUE, 
                    verbose = 0, prefix = tempfile(), 
                    save = 0, keep = 0, 
                    seed = 123, nstart = 1, 
                    best = TRUE, delta = 0.1, iter = 2000, 
                    burnin = 100, thin = 2000)
lda = LDA(df_dfm_trim, k = k, method = "Gibbs", 
          control = control_LDA)
terms(lda, 10)</code></pre>

Visualization
----------------
<pre class="r"><code># Terms within each topic
topics <- tidy(lda, matrix = "beta")
top_terms <- topics %>% group_by(topic) %>% 
  top_n(6, beta) %>% 
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>% mutate(term = reorder(term, beta)) %>% 
  ggplot(aes(term, beta, fill = factor(topic))) + 
  geom_col(show.legend = FALSE) + 
  facet_wrap(~ topic, scales = "free") + 
  coord_flip()</code></pre>

