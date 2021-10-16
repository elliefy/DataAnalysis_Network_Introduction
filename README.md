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

Mege node and edge files
----------------
<pre class="r"><code>#merge: note that not all Users in node feature file appeared in the edge list file
nodes = temp_total %>% left_join(temp_in, by = "Users") %>% left_join(temp_out, by = "Users") %>% left_join(df_num_msg, by = c("Users" = "to"))
nodes[is.na(nodes)] = 0
nodes = nodes %>%
  left_join(nodes0, by = "Users") %>% mutate_if(is.factor, as.character)
nodes$sex[is.na(nodes$sex)] = "na"
nodes$sex[is.na(nodes$edu2)] = "na"
nodes$sex[is.na(nodes$age_group)] = "na"
nodes$sex[is.na(nodes$live)] = "na"</code></pre>

Visualization
----------------
<pre class="r"><code>disc_net <- tidygraph::tbl_graph(nodes = nodes, 
                                 edges = edges1, directed = TRUE)
ggraph(disc_net, layout = 'nicely') + 
  geom_edge_link(aes(width = weight), alpha = 0.5) + 
  scale_edge_width(range = c(0.2, 1)) +
  geom_node_point(aes(color = as.factor(sex), size = in_degree))</code></pre>

