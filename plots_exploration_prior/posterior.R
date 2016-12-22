#Script to do the MCMC of the toy problem.

library(ggplot2)
library(DiceKriging)
data=read.csv('simulation_datab.csv')
measures=read.csv('experimental_data.csv');m=measures$measures

##GP fitting function

db=0.05
b=seq(0,15,by=db);n=length(b)
bstar=5;sigmab=sqrt(2.5)
stored_evolution=matrix(rep(0,n*10),n,10)

#####Adding the loop to see the evolution in information

for(j in 1:10){

	np=j #This is the number of experimental points to take into account

	m=m[1:np]


	y=rep(0,length(b));

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

	for(k in 1:np){
		t=data[k,3:12]
		train[,k]=as.numeric(t)
	}


	#Giving the output of the function G(b)=[G1(b),...,G10(b)]

	G=function(b){
		
		#b is a real number
		g=numeric(np)
		for(k in 1:np){
			g[k]=GP(train[,k],b)
		}
		return(g)
	}



	#Computing the nonconstant part of the posterior

	sigma=5.4e-3 #The value of the std for the noise
	posterior=function(b){
		#b is the point where we want to evaluate the function
		#sigma is the variance
		v=m-G(b)
		n=sum(v^2)
		C=-0.5/sigma^2
		e=n*C
		return(exp(e))
	}


	#####Ploting the posterior






	for(k in 1:length(b)){
		
		#y[k]=GP(train[,1],b[k])
		y[k]=posterior(b[k])*dnorm(b[k],mean=bstar,sd=sigmab)
	}

	#Finding the constant of integration
	Const=sum(y)*db
	y=y/Const
	print(Const)
	print(y)
	stored_evolution[,j]=y	
	if(j==2){
		break
	}

}

write.csv(stored_evolution,'stored_evolution.csv')
