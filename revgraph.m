format short
clc
clear all;
C=[3 2];
A=[2 4;3 5];
B=[8;15]; 
 y1=0:3:max(B);
x21=(B(1)-A(1,1).*y1)./A(1,2);
x22=(B(2)-A(2,1).*y1)./A(2,2);
x21=max(0,x21);
x22=max(0,x22);
plot(y1,x21,'r',y1,x22,'k')
xlabel('value of x1');
ylabel('value of x2');
title('x1 vs x2');
legend('2x1+4x2 = 8','3x1 + 5x2 = 15')
grid on
cx1=find(y1==0);
c1=find(x21==0);
line1=[y1(:,[c1 cx1]);x21(:,[c1 cx1])]';
c2=find(x22==0);
line2=[y1(:,[c2 cx1]);x22(:,[c2 cx1])]';
corpt=unique([line1;line2],'rows');
hg=[0;0];
for i=1:size(A,1)
    hg1=A(i,:);
    b1=B(i,:);
    for j=i+1:size(A,1)
        hg2=A(j,:);
        b2=B(j,:);
        Aa=[hg1;hg2];
        Bb=[b1;b2];
        xx=inv(Aa).*Bb;
        hg=[hg xx];
    end
end
pt=hg';
allpt=[pt;corpt];

points=unique(allpt,'rows');

pT=constraint(points);
pT=unique(pT,'rows');
Fx=[0;0];
for i=1:size(pT,1)
    Fx(i,:)=sum(pT(i,:).*C);
end
vert_Ens=[pT,Fx];
[fxval,indfx]=max(Fx);
optval=vert_Ens(indfx);
optimal=array2table(optval);
function hh=constraint(X)
x1=X(:,1);
x2=X(:,2);
cons1=2.*x1+4.*x2-8;
h1=find(cons1<0);
X(h1,:)=[];
x1=X(:,1);
x2=X(:,2);
cons2=3.*x1+5.*x2-15;
h2=find(cons2<0);
X(h2,:)=[];
hh=X;
end