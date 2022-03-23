clear
clc
var={'x1','x2','s1','s2','a1','a2','soln'};
M=1000;

%b=input("Enter the RHS of constraints\n");
%c=input("Enter the cost vector\n");

 c=[-3 -5 0 0 -M -M 0];
 a=[1 3 -1 0 1 0;1 1 0 -1 0 1];
b=[3;2];

A=[a b];
s=eye(size(A,1));

%to find initial bfs
bv=[];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            bv=[bv i];
        end
    end
end

%find Zj-Cj
B=A(:,bv);
A=inv(B)*A;
ZjCj=c(bv)*A-c;

run=true;
k=1;
while run
    ZjCjRow=ZjCj(:,1:end-1);
    if any(ZjCjRow<0)
        if k>1
            fprintf("Optimal soln. not reached yet.\n");
        end
        fprintf("------------------\nIteration %d:\n",k);
        k=k+1;
        fprintf("Previous Basic Variables = \n");
        disp(bv);
    
        %entering var.
        [entCol,pivCol]=min(ZjCjRow);
        fprintf("The entering variable is %d\n",pivCol);
    
        %leaving var.
        soln=A(:,end);
        valPivCol=A(:,pivCol);
        if all(valPivCol<=0)
            error("LPP unbounded as all entries <=0 in column %d",pivCol);
        else
            for i=1:size(A,1)
                if(valPivCol(i)>0)
                    ratio(i)=soln(i)./valPivCol(i);
                else
                    ratio(i)=inf;
                end
            end
            [minRatio,pivRow]=min(ratio);
            fprintf("The leaving variable is %d\n",bv(pivRow));
        end
    
        %update bv and table
        bv(pivRow)=pivCol;
        fprintf("Updated Basic Variables = \n");
        disp(bv);

        B=A(:,bv);
        A=inv(B)*A;
        ZjCj=c(bv)*A-c;
    
            
    else
        run=false;
        disp("Optimal Solution Reached.");
        
    end
end
bfs=zeros(1,size(A,2));
bfs(bv)=A(:,end);
bfs(end)=sum(bfs.*c);
valuesOfVariables=array2table(bfs);
valuesOfVariables.Properties.VariableNames(1:size(valuesOfVariables,2))=var