#Script to play around with llabels and legends

library(ggplot2)

state=c(T,F)
effect=c(0.5,1.0)
test=c('A','B')

df=expand.grid(Test=test,State=state,Effect=effect)

set.seed(1234)
df$Val=rnorm(nrow(df))

cols=c('T'='red','F'='green')
shapes=c('T'=15,'F'=10)

g=ggplot(data=df)
g=g+geom_point(aes(x=Test,y=Val,color=cols),size=4)
#g=g+scale_shape_manual(values=state)#breaks=c('T','F'))
g=g+scale_color_manual(values=state)

print(g)
