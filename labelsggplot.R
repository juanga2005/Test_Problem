#Script to play around with ggplot legends shit
library(ggplot2)
#Adding the first two layers
g=ggplot(data=mpg,aes(cty,hwy,col=as.factor(cyl)))+facet_grid(~class)+geom_point(size=3)

#Adding the layer of coloours given the values of cyl

#Adding the trending line
g=g+geom_smooth(aes(group=1,colour='Trendline'),method='loess',se=F,linetype='dashed')



#Here comes the overriding part

pivot=guide_legend(override.aes=list(linetype=c(rep('blank',4),'dashed'),shape=c(rep(16,4),NA)))
g=g+scale_colour_manual('This is the legend :)',values=c('purple','green','blue','yellow','red'),guide=pivot)

print(g)
