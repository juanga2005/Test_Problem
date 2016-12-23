#Script to plot the evolution in the light of the new evidence
library(ggplot2)



bstar=5;sigmab=sqrt(2.5) #This values are taken from posterior.R
pri=dnorm(b,bstar,sigmab)
df=read.csv('stored_evolution.csv');df=df[,-1];df=as.matrix(df)
n=dim(df)[1]
sites=matrix(rep(0,n*10),n,10)

for(k in 1:10){
		temp=rep(k,n)
		
		sites[,k]=temp
}
sites=expand.grid(sites);
b=seq(0,8,length=dim(df)[1])
B=rep(b,10);
P=rep(pri,10);
Tru=rep(0.925,n*10)
posterior=data.frame(b=B,posterior=expand.grid(df),site=sites,prior=P,TV=Tru)		
names(posterior)=c('b','post','site','prior','TV')




#Plotting

g=ggplot(posterior,aes(b,post),size=1)+facet_wrap(~site)
g=g+geom_line(aes(col='Posterior'))

#Plotting the prior
g=g+geom_line(aes(y=prior,col='Prior'))
g=g+scale_color_manual('Legend',values=c('black','red','green'))

#Adding the true value to the scale

g=g+geom_line(aes(x=TV,col='True value'))

#Labels
g=g+labs(x='b',y='P(b|m)',title='Evolution of the Posterior with Data Available')

g=g+theme(plot.title=element_text(hjust=0.5),legend.position=c(0.75,0.15))
print(g)

#Saving the plot
ggsave('../../Tesis/FigChap3/posterior_evolution.jpg')
