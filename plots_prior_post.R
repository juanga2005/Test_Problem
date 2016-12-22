#Scripts to do the plots of the prior and posterio
library(ggplot2)

#Creating the data frame
datos=read.csv('posterior.csv');posterior=datos[,-1];n=length(posterior)
b=seq(0,2,length=n);prior=rep(0.5,n);

df=cbind(b,prior,posterior)
df=as.data.frame(df)

#Creating the plot
g=ggplot(df,aes(b,posterior))+geom_line(aes(col='Posterior'))

#Adding points
g=g+geom_line(aes(y=prior,col='Prior'))
g=g+theme_bw()

#Adding the line with the true value
g=g+geom_vline(aes(col='True Value',xintercept=0.925),linetype='dashed')

#Chaning colors manual
pivot=guide_legend(override.aes=list(linetype=c('solid','solid','dashed')))
g=g+scale_color_manual('Distributions',values=c('blue','black','red'),guide=pivot)

#lables
g=g+labs(x='b',y='Distributions')+ggtitle('Prior and Posterior for b')+theme(plot.title=element_text(hjust=0.5))
g=g+xlim(c(0.8,1.1))

#Chaging the theme


ggsave('../Tesis/FigChap3/prior_posterior.jpg',g)



