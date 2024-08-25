cg <- colors()[substr(colors(),1,4)!="gray"]
d <- data.frame(c=cg, y=seq(0, length(cg)-1)%%56, x=seq(0, length(cg)-1)%/%56)
d$y <- 56-d$y
rm(cg)


p <- ggplot(d) +
    scale_x_continuous(name="", breaks=NULL, expand=c(0, 0)) +
    scale_y_continuous(name="", breaks=NULL, expand=c(0, 0)) +
    scale_fill_identity() +
    geom_rect(data=d, mapping=aes(xmin=x, xmax=x+1, ymin=y, ymax=y+1), fill="white") +
    geom_rect(data=d, mapping=aes(xmin=x+0.05, xmax=x+0.95, ymin=y+0.5, ymax=y+1, fill=c)) +
    geom_text(data=d, mapping=aes(x=x+0.5, y=y+0.5, label=c), colour="black", hjust=0.5, vjust=1, size=3) + 
    labs(title="Default R Colour Names") +
    theme(title =element_text(size=12, face='bold',hjust=0.5),
          plot.title = element_text(hjust = 0.5, margin=margin(0,0,10,0)))
plot(p)
rm(d)
rm(p)

