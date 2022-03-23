clear
clc
%A=input("Enter the coefficients of constraints\n");
%b=input("Enter the RHS of constraints\n");
%c=input("Enter the cost vector\n");
 A=[1 4 8 6;4 1 2 1;2 3 1 2];
 b=[11;7;2];
 c=[4 6 3 1];

s=eye(size(A,1));
tab=[A s b];
m=size(A,2);

e=zeros(1,size(A,1)+1);
cost=[c e];

bv=m+1:1:size(tab,2)-1;
ZjCj=cost(bv)*tab-cost;
tabpr=[tab;ZjCj];

simplexTable=array2table(tabpr);
simplexTable.Properties.VariableNames(1:size(tabpr,2))={'x1','x2','x3','x4','s1','s2','s3','soln'}

run=true;
k=1;
while run
    if any(ZjCj<0)
        if k>1
            fprintf("Optimal soln. not reached yet.\n");
        end
        fprintf("------------------\nIteration %d:\n",k);
        k=k+1;
        fprintf("Previous Basic Variables = \n");
        disp(bv);
    
        %entering var.
        ZjCjRow=ZjCj(1:end-1);
        [entCol,pivCol]=min(ZjCjRow);
        fprintf("Most negative element in Zj-Cj is %d corresponding to the column %d\nHence the entering variable is %d\n",entCol,pivCol,pivCol);
    
        %leaving var.
        soln=tab(:,end);
        valPivCol=tab(:,pivCol);
        if all(valPivCol<=0)
            error("LPP unbounded as all entries <=0 in column %d",PivCol);
        else
            for i=1:size(tab,1)
                if(valPivCol(i)>0)
                    ratio(i)=soln(i)./valPivCol(i);
                else
                    ratio(i)=inf;
                end
            end
            [minRatio,pivRow]=min(ratio);
            fprintf("Minimum ratio is %d corresponding to the row %d\nHence the leaving variable is %d\n",minRatio,pivRow,bv(pivRow));
        end
    
        bv(pivRow)=pivCol;
        fprintf("Updated Basic Variables = \n");
        disp(bv);
    
        %pivot key
        pivKey=tab(pivRow,pivCol);
        fprintf("Pivot element = %f \n",pivKey);
    
        %updation of table
        tab(pivRow,:)=tab(pivRow,:)./pivKey;
        for i=1:size(tab,1)
            if i~=pivRow
                tab(i,:)=tab(i,:)-tab(i,pivCol).*tab(pivRow,:);
            end
        end
            ZjCj=ZjCj-ZjCj(pivCol).*tab(pivRow,:);
            tabpr=[tab;ZjCj];
            simplexTable=array2table(tabpr);
            simplexTable.Properties.VariableNames(1:size(tabpr,2))={'x1','x2','x3','x4','s1','s2','s3','soln'}
    
            bfs=zeros(1,size(tab,2));
            bfs(bv)=tab(:,end);
            bfs(end)=sum(bfs.*cost);
    else
        run=false;
        disp("Optimal Solution Reached.");
        valuesOfVariables=array2table(bfs);
        valuesOfVariables.Properties.VariableNames(1:size(valuesOfVariables,2))={'x1','x2','x3','x4','s1','s2','s3','soln'}
    end
end
