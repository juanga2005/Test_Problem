#Script to do the MCMC of the toy problem.

library(ggplot2)
library(DiceKriging)
data=read.csv('simulation_datab.csv')
measures=read.csv('experimental_data.csv');m=measures$measures

##GP fitting function

GP=function(dat,b){
	#dat is the data to create the km object a numeric vector
	#b is the point where the GP gives the value
	dd=seq(0.2,2,by=0.2)
	model=km(design=data.frame(x=dd),response=data.frame(y=dat))
	
	p=predict(object=model,newdata=data.frame(x=b),type='UK')$mean
	
	return(p)
}


#Preparing all the training points
train=matrix(rep(0,10*10),10,10)

for(k in 1:10){
	t=data[k,3:12]
	train[,k]=as.numeric(t)
}


#Giving the output of the function G(b)=[G1(b),...,G10(b)]

G=function(b){
	
	#b is a real number
	g=numeric(10)
	for(k in 1:10){
		g[k]=GP(train[,k],b)
	}
	return(g)
}



#Computing the nonconstant part of the posterior

sigma=1e-2 #The value of the std for the noise
posterior=function(b){
	#b is the point where we want to evaluate the function
	#sigma is the variance
	v=m-G(b)
	n=sum(v^2)
	C=-0.5/sigma^2
	e=n*C
	b=1/(sqrt(2*pi)*sigma)
	return(b*exp(e))
}



#####Ploting the posterior

b=seq(0,2,by=0.01)

y=numeric(length(b));





for(k in 1:length(b)){
	
	#y[k]=GP(train[,1],b[k])
	y[k]=posterior(b[k])
}

write.csv(y,'posterior.csv')
