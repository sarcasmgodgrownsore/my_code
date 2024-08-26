show_colours <- function () {
    library("ggplot2")
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
}


show_point_types <- function() {
    oldPar <- par()
    par(font = 2, mar = c(0.5, 0, 0, 0))
    y = rev(c(rep(1, 6), rep(2, 5), rep(3, 5), rep(4, 5), rep(5, 5)))
    x = c(rep(1:5, 5), 6)
    plot(
        x,
        y,
        pch = 0:25,
        cex = 1.5,
        ylim = c(1, 5.5),
        xlim = c(1, 6.5),
        axes = FALSE,
        xlab = "",
        ylab = "",
        bg = "blue"
    )
    text(x, y, labels = 0:25, pos = 3)
    par(mar = oldPar$mar, font = oldPar$font)
    title(main = "R Point Symbols")
}



show_line_types <- function() {
    oldPar<-par()
    par(font=2, mar=c(0,0,0,0))
    plot(1, pch="", ylim=c(0,6), xlim=c(0,0.7),  axes=FALSE,xlab="", ylab="")
    for(i in 0:6) lines(c(0.3,0.7), c(i,i), lty=i, lwd=3)
    text(rep(0.1,6), 0:6, labels=c("0.'blank'", "1.'solid'", "2.'dashed'", "3.'dotted'",
                                   "4.'dotdash'", "5.'longdash'", "6.'twodash'"))
    par(mar=oldPar$mar,font=oldPar$font )
}
