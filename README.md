Brief Introduction - Network visualization in online discussion forum
----------------
This tutorial introduced how to construe and visualize a network from "post-reply" relations in an online forum dataset.

Preparation - Install packages
----------------
<pre class="r"><code>pkgs = c("tidyverse", "igraph","stringr","igraph", "ggraph", "tidygraph")
#load packages
ld_pkgs = lapply(pkgs, library, character.only = TRUE)</code></pre>

Pre-Process data frames and create node/edge files
----------------
<pre class="r"><code>#create node list
sources <- df %>%
  distinct(author) 
destinations <- df %>%
  distinct(user) 
nodes <- full_join(sources, destinations, by = "label")
nodes

#edge list
edges = df %>% select(user, author)
edges1 = edges %>% count(user, author) %>% ungroup() %>%  rename(weight = n)</code></pre>

Visualization
----------------
<pre class="r"><code>net <- graph_from_data_frame(d=edges1, vertices=nodes, directed=T)
net = igraph::simplify(net) # remove self to self and duplicates

net2 = igraph::delete.vertices(net, degree(net)==0) # remove vertices without in and out
E(net2)$width <- 1+E(net2)$weight/6 # edge width = weight</code></pre>

Output graph
----------------
<pre class="r"><code>png(file="Reddit_demo.png",
    width=1000, height=1000)
plot(net2,vertex.label=NA,vertex.size = 2,
     vertex.label=TRUE)
#plot(net2,vertex.label=NA, vertex.size = 1, rescale=FALSE,layout=l)
dev.off()</code></pre>

Degree index
----------------
<pre class="r"><code>#all degree
temp_total = as.data.frame(table(c(as.character(df$author), as.character(df$user))))
colnames(temp_total) = c("Users","total_degree")
#in degree
temp_in = as.data.frame(table(df$author))
colnames(temp_in) = c("Users","in_degree")
#out degree
temp_out = as.data.frame(table(df$user))
colnames(temp_out) = c("Users","out_degree")</code></pre>

