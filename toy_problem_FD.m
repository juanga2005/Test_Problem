%Script that solves the problem -\Delta u=a*exp(-b*\|x\|) in R^2 in \Omega and u=0 on \partial\Omega
%We use finite differences to solve the problem
%\Omega=[0,alpha]\times [0,beta]

%Author: Juan Garcia
%date: May 4 of 2016

%Modifications:
%May 5 of 2016: Change the script to become a function
%May 6 of 2016: The function is completed

function [xcord,ycord,medidas]=toy_problem_FD(a,b,dx,N)
%Function that takes a,b positive real numbers as parameters in the exponential
%dx is the mesh size and N is the number of sample points 
%xcord and ycord  are the x and y coordinates of the variable medidas
%medidas is the measurement done at the N different points




	%Physical parameters
	alpha=1;beta=0.925;

	%Paraters for the numerics
	dy=dx;n=alpha/dx;m=alpha/dy;
	x=0:dx:alpha;y=x;
	[xx,yy]=meshgrid(x(2:n),y(2:m));




	%Solution vectors
	u=zeros((n-1)*(m-1),1);
	e=ones(n-1,1);
	A=spdiags([-e 2*e -e],-1:1,n-1,n-1);
	I=eye(n-1);


	L=kron(I,A)+kron(A,I);

	L=L/dx^2;

	%Source function

	xx=xx(:);yy=yy(:);

	f=a*exp(b*(-xx.^2-yy.^2));


	%Solving the equation

	u=L\f;

	%Reshape u

	uu=zeros(n+1,n+1); uu(2:n,2:n)=reshape(u,n-1,n-1);



	%Obtaining the sample points

	rng(5);
	
	rnum=randi([1 (n-1)^2],1,N);
	
	%outputs	
	medidas=u(rnum);
	xcord=xx(rnum);
	ycord=yy(rnum);	


	%Here comes the plotting

	[xx,yy]=meshgrid(x,y);


	contourf(xx,yy,uu);
	hold on;
	plot(xcord,ycord,'.','MarkerSize',20,'col','k');	
	
	%surf(xx,yy,uu,'EdgeColor','none');
	%hold on 
	%scatter3(xcord,ycord,medidas,'o');
	colorbar;

	xlabel('x');ylabel('y');title('Solution u(x,y) with b=0.925');

end
