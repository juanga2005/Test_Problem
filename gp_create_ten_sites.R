#Script to do all the gp fit


library(DiceKriging)

data=read.csv('simulation_datab.csv')



#Recalling how to do the fitting for ones of the experimental points

test=seq(0,2,by=0.01);m=length(test)
training=seq(0.2,2,by=0.2);

n=10 #Number of measurement sites
predicted.values=matrix(rep(0,m*n),m,n)

for(k in 1:n){
	#Extracting the training data
	resp=as.numeric(data[k,3:12])

	#Creating the km object

	mod=km(design=data.frame(x=training),response=data.frame(y=resp))

	#Create the prediction

	predicted.values[,k]=predict(object=mod,newdata=data.frame(x=test),type='UK')$mean


	#Plotting

}

write.csv(predicted.values,'predictedvalues.csv')

