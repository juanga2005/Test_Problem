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

sigma=2e-3 #The value of the std for the noise
posterior=function(b){
	#b is the point where we want to evaluate the function
	#sigma is the variance
	v=m-G(b)
	n=sum(v^2)
	C=-0.5/sigma^2
	e=n*C
	return(exp(e))
}



###Implementing the Metropolis Hastings

nsim=10000 #Number of steps I want to take

X=numeric(nsim);X[1]=1#Initializing X
delta=0.05; #Step size

for(k in 1:nsim){
	y=runif(1,X[k]-delta,X[k]+delta) #Proposed step

	#Creating pi(X)
	gx=G(X[k]);
	
	#Checking that steps belongs to [0,2]
	if(y<=2 & y>=0){
		gy=G(y)
	}
	else{
		gy=0
	}

	#Checkingn the acceptance

	rho=min(1,gy/gx)
	X[k+1]=X[k]+(y-X[k])*(runif(1)<rho)
}


