function [M]=T_Move2Position_foot(GeS,proximal)

%Compute the rototranslation matrix from the GeS coordinate - foot convention, rotation in degrees.
%N.B. no change in the sing are here considered due to the medical
%convention. Thus the sign are those of the GeS axes
[m,n] = size(GeS);

for i=1:m
    flexZ=GeS(i,1);
    abdX=GeS(i,2);
    rotY=GeS(i,3);
    x=GeS(i,4);
    y=GeS(i,5);
    z=GeS(i,6);

    flexZ = flexZ*pi/180;
    abdX = abdX*pi/180;
    rotY = rotY*pi/180;

    if proximal == true
    %//TALUS respct to SCAPHOID - RxRyRz
        %RxRyRz
        %CyCz  -CySz  Sy
        %(CxSz + SxSyCz)  (CxCz - SxSySz)  -SxCy
        %(SxSz - CxSyCz)  (SxCz + CxSySz)  CxCy
        
        T(1,1)= cos(rotY)*cos(flexZ);
        T(2,1)= cos(abdX)*sin(flexZ) + sin(abdX)*sin(rotY)*cos(flexZ);
        T(3,1)= sin(abdX)*sin(flexZ) - cos(abdX)*sin(rotY)*cos(flexZ);

        T(1,2)= -cos(rotY)*sin(flexZ) ;
        T(2,2)= cos(abdX)*cos(flexZ) - sin(abdX)*sin(rotY)*sin(flexZ);
        T(3,2)= sin(abdX)*cos(flexZ) + cos(abdX)*sin(rotY)*sin(flexZ);

        T(1,3)= sin(rotY);
        T(2,3)= -sin(abdX)*cos(rotY);
        T(3,3)= cos(abdX)*cos(rotY);
    else
    %//SCAPHOID respectto TALUS - RzRyRx
        %RzRyRx
        %CzCy  (CzSySx - SzCx)  (CzSyCx + SzSx)
        %SzCy  (SzSySx + CzCx)  (SzSyCx - CzSx)
        %-Sy  CySx CyCx
        
        T(1,1)= cos(flexZ)*cos(rotY);
        T(2,1)= sin(flexZ)*cos(rotY);
        T(3,1)= -sin(rotY);

        T(1,2)= cos(flexZ)*sin(rotY)*sin(abdX) - sin(flexZ)*cos(abdX);
        T(2,2)= sin(flexZ)*sin(rotY)*sin(abdX) + cos(flexZ)*cos(abdX);
        T(3,2)= cos(rotY)*sin(abdX);

        T(1,3)= cos(flexZ)*sin(rotY)*cos(abdX) + sin(flexZ)*sin(abdX);
        T(2,3)= sin(flexZ)*sin(rotY)*cos(abdX) - cos(flexZ)*sin(abdX);
        T(3,3)= cos(rotY)*cos(abdX);
    end

    T(1,4)= x;
    T(2,4)= y;
    T(3,4)= z;
    T(4,:)= [0 0 0 1];

    if m ==1
        M = [T(1,:);T(2,:);T(3,:);T(4,:)];
    else
        M(i,:) = [T(1,:),T(2,:),T(3,:),T(4,:)];
    end
end