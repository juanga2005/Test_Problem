%Script to give the output of the data given by the function toy_problem_FD.m



a=1;dx=0.01;N=10;

m=1; %--> Number of repetitions
measures=zeros(N,m);
b=0.925;
[x,y,measures]=toy_problem_FD(a,b,dx,N);

%Adding some noise to the measurements
%rng(3);
measures2=measures;
measures=measures+normrnd(0,0.002,N,1);
measures-measures2

T=table(x,y,measures);
writetable(T,'experimental_data.csv','Delimiter',',');
