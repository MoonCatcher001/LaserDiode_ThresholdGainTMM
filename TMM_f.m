%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Igor A. Sukhoivanov and Igor V. Guryev
% Photonic Cristals: Physical and Practical Modeling
% Chap3: Fundamentals of Computation of Photonic Crystal Characteristics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% j is the index of the layer
% Ej(z) = Aj*exp(i*nj*k*zj) + Bj*exp(-i*nj*k*zj)       => 2N+2 equations system
% Aj and Bj are the unknown coefficient we want to get => 2N+4 unknowns
% We set as boundary conditions,
% A0=1 (input amplitude on the left side) and BN+1=0 (no input amplitude on the right side)

% Ej(zj) = Ej+1(zj)
% d/dz*Ej(zj) = d/dz*Ej+1(zj)

% M=[
%         exp(-ikn0z0)      -exp(ikn1z0)       -exp(-ikn1z0)            0                 0                  0                 0             ...
%   -ikn0.exp(-ikn0z0) -ikn1.exp(ikn1z0)  +ikn1.exp(-ikn1z0)            0                 0                  0                 0             ...
%            0               exp(ikn1z1)        exp(-ikn1z1)       -exp(ikn2z1)       -exp(-ikn2z1)          0                 0             ...
%            0          ikn1.exp(ikn1z1)  -ikn1.exp(-ikn1z1)  -ikn2.exp(ikn2z1)  +ikn2.exp(-ikn2z1)          0                 0             ...
%            0                  0                   0               exp(ikn2z2)        exp(-ikn2z2)       -exp(ikn3z2)      -exp(-ikn3z2)    ...
%            0                  0                   0          ikn2.exp(ikn2z2)  -ikn2.exp(-ikn2z2)  -ikn3.exp(ikn3z2) +ikn3.exp(-ikn3z2)    ...
%            0                  0                   0                   0                 0                  0                 0             ...
%            0                  0                   0                   0                 0                  0                 0             ...
% ]

% AB= [B0 ; A1 ; B1 ; A2 ; B2 ; A3 ; B3 ; .... AN ; BN ; AN+1]


function[A,B,psi]=TMM_f(zz,zv,nt,nL,nR,lambda)

AmplitudeInput=1;
k=2*pi/lambda;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Left bondary condition
M=[];

M(1,1:3)=[1 -1 -1];
M(2,1:3) = [-1i*k*nL -1i*k*nt(1)  1i*k*nt(1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filling the matrix

for j=1:length(nt)-1

  M(j*2+1,2*j:2*j+3) = [exp(1i*k*nt(j)*zz(j)) exp(-1i*k*nt(j)*zz(j)) -exp(1i*k*nt(j+1)*zz(j)) -exp(-1i*k*nt(j+1)*zz(j))];

  M(j*2+2,2*j:2*j+3) = ...
  [1i*k*nt(j)*exp(1i*k*nt(j)*zz(j)) -1i*k*nt(j)*exp(-1i*k*nt(j)*zz(j)) -1i*k*nt(j+1)*exp(1i*k*nt(j+1)*zz(j)) 1i*k*nt(j+1)*exp(-1i*k*nt(j+1)*zz(j))];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Right bondary condition

M(length(nt)*2+1,2*length(nt):2*length(nt)+2)= [exp(1i*k*nt(end)*zz(j+1)) exp(-1i*k*nt(end)*zz(j+1)) -exp(1i*k*nR*zz(j+1))];

M(length(nt)*2+2,2*length(nt):2*length(nt)+2)= [1i*k*nt(end)*exp(1i*k*nt(end)*zz(j+1)) -1i*k*nt(end)*exp(-1i*k*nt(end)*zz(j+1)) -1i*k*nR*exp(1i*k*nR*zz(j+1))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D=zeros(length(M),1);
D(1)=-sqrt(AmplitudeInput);
D(2)=-sqrt(AmplitudeInput)*1i*k*nL;

AB=inv(M)*D;
A=[1 ; AB(2:2:end)];
B=[AB(1:2:end-1) ; 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psi=[];
for j=1:length(nt)
  
  psi= [ psi  A(j+1)*exp(1i*k*nt(j)*zv{j}) + B(j+1)*exp(-1i*k*nt(j)*zv{j}) ];
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%