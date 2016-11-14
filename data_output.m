%Script to give the output of the data given by the function toy_problem_FD.m



a=1;dx=0.01;N=10;

m=10; %--> Number of repetitions
measures=zeros(N,m);
%for loop for different values of a

spacing=0.20; %---> This is the variable that sets how to distribute on a


for j=1:m
	b=spacing*j;
	[x,y,measures(:,j)]=toy_problem_FD(a,b,dx,N);
end	
%measures=measures+normrnd(0,0.01,m,m);
T=table(x,y,measures);
writetable(T,'simulation_datab.csv','Delimiter',',');
