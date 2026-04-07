function [GeS] = GeS_Compute_Coordinates_foot(T,proximal)

% return the GeS coordinated associated to the matrix T for the foot convention.
% the proximal bone has a fixed z axis, di distal bone a fixed x axis, y is floating. T is in line,
% rotation are in degrees. No change in the sing of the axes are introduced
% to match medical conventions


[m,n] = size(T);
if n==4
    m=1;
end

for i=1:m
    if n == 16
        for j=1:4
            M(j,1:4)=T(i,(1+4*(j-1)):4*j);
        end
    elseif n == 4
        M=T;
    end
    
    if proximal == true
        %//TALUS respct to SCAPHOID - RxRyRz
        %RxRyRz
        %CyCz  -CySz  Sy
        %(CxSz + SxSyCz)  (CxCz - SxSySz)  -SxCy
        %(SxSz - CxSyCz)  (SxCz + CxSySz)  CxCy

        GeS(i,3)=atan2(M(1,3),sqrt(M(1,1)^2+M(1,2)^2))* 180 / pi;

        %we want the IE angle angle to be comprise betwee -pi/2 and pi/2 thus
        if(GeS(i,3)<-90)
            GeS(i,3)= -180 - GeS(i,3);
        elseif(GeS(i,3)>90)
            GeS(i,3)= 180 - GeS(i,3);
        end

        GeS(i,2)=atan2(-M(2,3)/cos(GeS(i,3)*pi/180),M(3,3)/cos(GeS(i,3)*pi/180))* 180 / pi;
        GeS(i,1)=atan2(-M(1,2)/cos(GeS(i,3)*pi/180),M(1,1)/cos(GeS(i,3)*pi/180))* 180 / pi;
    else
        %//SCAPHOID respectto TALUS - RzRyRx
        %RzRyRx
        %CzCy  (CzSySx - SzCx)  (CzSyCx + SzSx)
        %SzCy  (SzSySx + CzCx)  (SzSyCx - CzSx)
        %-Sy  CySx CyCx
        
        GeS(i,3)=atan2(-M(3,1),sqrt(M(3,2)^2+M(3,3)^2))* 180 / pi;

        %we want the IE angle angle to be comprise betwee -pi/2 and pi/2 thus
        if(GeS(i,3)<-90)
            GeS(i,3)= -180 - GeS(i,3);
        elseif(GeS(i,3)>90)
            GeS(i,3)= 180 - GeS(i,3);
        end

        GeS(i,2)=atan2(M(3,2)/cos(GeS(i,3)*pi/180),M(3,3)/cos(GeS(i,3)*pi/180))* 180 / pi;
        GeS(i,1)=atan2(M(2,1)/cos(GeS(i,3)*pi/180),M(1,1)/cos(GeS(i,3)*pi/180))* 180 / pi;
    end

	GeS(i,4)=M(1,4);
	GeS(i,5)=M(2,4);
	GeS(i,6)=M(3,4);
end