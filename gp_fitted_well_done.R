#hjScript to fit the values of the prediction of the GP fit

library(ggplot2)

#Loading the GP data
dataGP=read.csv('predictedvalues.csv');dataGP=dataGP[,-1]
#names(dataGP)=c('pt1','pt2','pt3','pt4','pt5','pt6','pt7','pt8','pt9','pt10')


dataexp=read.csv('experimental_data.csv');measures=dataexp$measures
#Loading the Simulation data
dataSimulation=read.csv('simulation_datab.csv')
test=seq(0,2,by=0.01);train=seq(0.2,2,by=0.2);n=length(test)
#Organizing the data
expm=matrix(rep(0,10*n),n,10);

sites=matrix(rep(0,n*10),n,10)
for(k in 1:10){
	temp=rep(k,n)
	sites[,k]=temp
	expm[,k]=rep(measures[k],n);
}

sites=expand.grid(sites)
trueb=rep(0.925,10*n);
expm=expand.grid(expm);
GP=expand.grid(as.matrix(dataGP))
yy=seq(0,0.08,length.out=length(trueb)/10)
yy=rep(yy,10);
data=data.frame(site=sites,b=test,GPfit=GP,btrue=trueb,measures=expm,y=yy)
names(data)=c('site','b','GPfit','btrue','expmeasure','yy')


#Creating new data for the points
nn=length(train)
sites2=matrix(rep(0,10*nn),nn,10)
dsim=matrix(rep(0,10*nn),nn,10);
for(k in 1:10){
	temp=rep(k,nn)
	sites2[,k]=temp
	dsim[,k]=as.numeric(dataSimulation[k,3:12])
}
dsim=expand.grid(dsim)
sites2=expand.grid(sites2)
simul=data.frame(sites=sites2,t=rep(train,10),meas=dsim);
names(simul)=c('site','bten','y')

#Starting the plotting part
g=ggplot(data,aes(b),size=1)+facet_wrap(~site)+geom_line(aes(y=GPfit,colour='GP Fit Over Test Points'))

#Adding the trueb and expm
g=g+geom_line(aes(x=btrue,y=yy,colour='True Value of b'),linetype='dashed')
g=g+geom_line(aes(y=expmeasure,colour='Experimental Measure at the Site'),linetype='dashed')

g=g+geom_point(data=simul,aes(x=bten,y=y,col='Numerical Solution u At the Site'))
#Adding the labels and legends
pivot=guide_legend(override.aes=list(linetype=c('dashed','solid','blank','dashed'),shape=c(NA,NA,16,NA)))
g=g+scale_color_manual('Legend',values=c('blue','green','red','black'),guide=pivot)

g=g+labs(x='b',y=expression(tilde(u)(x,b)),title='Numerical Solution and GP Fit for
each of the Ten Sites')
g=g+theme(plot.title=element_text(hjust=0.5),legend.position=c(0.75,0.15))







#
##adding the first layer
#g=g+geom_point(data=data2,aes(x=train,y=output,color='Emulator output'),size=1)#Adding the points
#g=g+geom_line(aes(y=fit,color='GP fit'),linetype='solid')#size=0.5) #Adding the fits
#
#
##telling ggplot to put the true exp measurement in each facet
#interm=data.frame(location=levels(as.factor(data$location)),y=measures)
#interm2=data.frame(location=levels(as.factor(data$location)),y=rep(0.925,10))
#
#
#g=g+geom_hline(data=interm,aes(yintercept=measures,color='Experimental Measure'),linetype='dashed')
#g=g+geom_vline(data=interm2,aes(xintercept=y,color='Real b value'),linetype='dashed')
#
##adding labels
#
##adding legends
#bb=values=c('green','red','blue','black')
#a=guide_legend(override.aes=list(linetype=c('blank','dashed','solid','dashed'),shape=c(16,NA,NA,NA)))
#g=g+scale_colour_manual('Legend',values=c('black','blue','red','purple'),guide=a)
#
#g=g+theme(legend.position=c(0.7,0.2))
#
#g=g+labs(title='Ilustration of GP',x='b',y='Output')
ggsave('../Tesis/FigChap3/fitted.jpg',g)
#print(g)
	
	
	
