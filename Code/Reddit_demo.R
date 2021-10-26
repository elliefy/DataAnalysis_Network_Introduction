pkgs = c("tidyverse", "igraph","stringr","igraph", "ggraph", "tidygraph")
#load packages
ld_pkgs = lapply(pkgs, library, character.only = TRUE)

df = read.csv("Reddit_comment.csv")

#create node list
sources <- df %>%
  distinct(author) 
destinations <- df %>%
  distinct(user) 
nodes <- full_join(sources, destinations, by = "label")
nodes

#edge list
edges = df %>% select(user, author)
edges1 = edges %>% count(user, author) %>% ungroup() %>%  rename(weight = n) 

#visual
net <- graph_from_data_frame(d=edges1, vertices=nodes, directed=T)
net = igraph::simplify(net) # remove self to self and duplicates

net2 = igraph::delete.vertices(net, degree(net)==0) # remove vertices without in and out
E(net2)$width <- 1+E(net2)$weight/6 # edge width = weight

png(file="Reddit_demo.png",
    width=1000, height=1000)
plot(net2,vertex.label=NA,vertex.size = 2,
     vertex.label=TRUE)
#plot(net2,vertex.label=NA, vertex.size = 1, rescale=FALSE,layout=l)
dev.off()

#all degree
temp_total = as.data.frame(table(c(as.character(df$author), as.character(df$user))))
colnames(temp_total) = c("Users","total_degree")
#in degree
temp_in = as.data.frame(table(df$author))
colnames(temp_in) = c("Users","in_degree")
#out degree
temp_out = as.data.frame(table(df$user))
colnames(temp_out) = c("Users","out_degree")




