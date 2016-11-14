#Script to explore the data output of the scripts data_experimental.m and data_output.m


#Author: Juan Garcia
#email: jggarcia@sfu.ca
#Date: Nov 13 2016

library(ggplot2)

exper=read.csv('experimental_data.csv')
synt=read.csv('simulation_datab.csv')

data=data.frame()
b=seq(0.2,2,by=0.2);

#Organizing the data
for(k in 1:10){
	output=as.numeric(synt[k,3:12])
	location=rep(k,10);
	temp=cbind(location,b,output)
	
	data=rbind(data,temp);
}
data$location=as.factor(data$location)	






hmm=data.frame(location=levels(data$location),z=exper$measures)
#
#
#
##Plotting the results from the emulator
#
#
##plot(b,synt[1,3:12]); abline(h=exper[1,3],col='red')
#
#
g=ggplot(data,aes(b))+facet_wrap(~location)

g=g+geom_hline(data=hmm,aes(yintercept=z,color='Experimental Measurements'))#color='Experimental Masures'))

g=g+geom_point(aes(y=output,color='Emulator'))+scale_alpha_manual(values=c(0,1))#color='Emulator Results'))

g=g+ggtitle('Emulator Output for Each of the 10 Measuremente Sites')+xlab('Value of the Parameter b')

g=g+ylab('Solution u')+theme_bw()


g=g+scale_color_manual(values=c('black','black'),
guide=guide_legend(override.aes=list(linetype=c('solid','blank'),shape=c(NA,16)),title='Legend'))
#g=g+guides(color=guide_legend(override.aes=list(linetype=c(1,0),shape=c(NA,16))))
g=g+theme(legend.position=c(0.7,0.2))

print(g)

ggsave('../Tesis/FigChap3/nofitted.jpg')
