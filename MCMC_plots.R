#Script to do all the plots of the MCMC shit
library(ggplot2)


d=read.csv('MCMCresult.csv');d=d[,-1] #The data where the results from the MCMC simulation are
post=read.csv('posterior.csv');post=post[,-1];n=length(post)
#Removing the burning out period

samp=d[5000:10000] #The data to work with

b=seq(0,2,length=n);

#Creating the data set
df=data.frame(b=b,posterior=post)

#Creating the histogram

g=ggplot(as.data.frame(x=samp),aes(samp))+geom_histogram(aes(fill=..count..),binwidth=0.0227)
g=g+scale_fill_gradient('count',low='green',high='red')+aes(y=..density..)


#Adding the density line
g=g+geom_line(data=df,aes(b,posterior))+xlim(c(0.78,1.073))
g=g+labs(x='b',y='Posterior',title='Histogram for the MCMC')

#Twitching the plot
g=g+theme(plot.title=element_text(hjust=0.5))

ggsave('../Tesis/FigChap3/histogram_mcmc.jpg',g)



#x11()
#hist(samp,prob=T,xlab='b',ylab='P(b|m)',main='Histogram for the MCMC',ylim=c(0,9))
#lines(b,post)

