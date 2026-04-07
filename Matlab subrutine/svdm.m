function [R,T] = svdm(X,Y)
% SVDM  6 DoF estimation using SingularValueDecomposition algorithm
%       [R,T] = SVDM(X,Y) return estimated rotation matrix and 
%       translation vector by means of the Singular Value Decomposition
%       (SVD) non-itherative algorithm.
%       The relationship between X and Y is: Y[i]=R*X[i]+T+e[i]
%       where e[i] represents additive aleatory noise
%       (ver. for Nm=4 and 1 frame)
% ------------------------------------------------------------------------
% INPUT:
% X (3 x Nm) : local  (model)     x,y,z marker coordinates for all mrks
% Y (3 x Nm) : global (collected) x,y,z marker coordinates for all mrks
% ------------------------------------------------------------------------
% OUTPUT:
% R (3 x 3)  : estime of the rotation matrix
% T (3 x 1)  : estime of the translation vector
% -------------------------------------------------------------------------
% Ref.: Determining the movements of the skeleton using well-configured markers
%       Soderkvist and Wedin; J Biomechanics 1993; 26(12) 1473-1477
% Auth: A Leardini 25/1/96
% See:  WLS_MOD, SVD_DOF, SVDPAR

Nm=size(X,2);   % number of markers
one=ones(1,Nm); % row of Nm 1_value

Lm=mean(X')'; MLm=Lm*one; % centroid coord. in the Local  frame
Pm=mean(Y')'; MPm=Pm*one; % centroid coord. in the Global frame
Xg=X-MLm;                 % local  marker coord. with Origin in the centroid
Yg=Y-MPm;                 % global marker coord. with Origin in the centroid

Z=Yg*Xg';
[U D V]=svd(Z);   % Singular Value Decomposition (SVD)

R=U*diag([1 1 det(U*V')])*V';  % rotation matrix
T=Pm-R*Lm;                     % translation vector


