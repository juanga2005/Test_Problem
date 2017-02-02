#hjScript to fit the values of the prediction of the GP fit

library(ggplot2)

#Loading the GP data
dataGP=read.csv('predictedvalues.csv');dataGP=dataGP[,-1]
#names(dataGP)=c('pt1','pt2','pt3','pt4','pt5','pt6','pt7','pt8','pt9','pt10')


dataexp=read.csv('experimental_data.csv');measures=dataexp$measures
#Loading the Simulation data
dataSimulation=read.csv('simulation_datab.csv')
test=seq(0,2,by=0.01);train=seq(0.2,2,by=0.2)
#Organizing the data
data=data.frame();data2=data.frame()
n=10
for(k in 1:n){
	fit=dataGP[,k];l=length(fit)
	location=rep(k,l)
	temp=cbind(test,fit,location)
	data=rbind(data,temp)

	output=as.numeric(dataSimulation[k,3:12])
	location=rep(k,10)
	temp=cbind(train,output,location)
	data2=rbind(data2,temp)
}





#Starting the plotting part
g=ggplot(data,aes(test),size=1)+facet_wrap(~location)

#Adding the first layer
g=g+geom_point(data=data2,aes(x=train,y=output,color='Emulator output'),size=1)#Adding the points
g=g+geom_line(aes(y=fit,color='GP fit'),linetype='solid')#size=0.5) #Adding the fits


#Telling ggplot to put the true exp measurement in each facet
interm=data.frame(location=levels(as.factor(data$location)),y=measures)
interm2=data.frame(location=levels(as.factor(data$location)),y=rep(0.925,10))


g=g+geom_hline(data=interm,aes(yintercept=measures,color='Experimental Measure'),linetype='dashed')
g=g+geom_vline(data=interm2,aes(xintercept=y,color='Real b value'),linetype='dashed')

#Adding labels

#Adding legends
bb=values=c('green','red','blue','black')
a=guide_legend(override.aes=list(linetype=c('blank','dashed','solid','dashed'),shape=c(16,NA,NA,NA)))
g=g+scale_colour_manual('Legend',values=c('black','blue','red','purple'),guide=a)

g=g+theme(legend.position=c(0.7,0.2))

g=g+labs(title='Ilustration of GP',x='b',y='Output')
#ggsave('../Tesis/FigChap3/fitted.jpg',g)
print(g)
	
	
	
