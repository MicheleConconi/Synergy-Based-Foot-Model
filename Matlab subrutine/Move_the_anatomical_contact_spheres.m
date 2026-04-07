function [moved_ana_CS] = Move_the_anatomical_contact_spheres(CS_ana,x,SYN)
%the function take a set of contact spheres in the anatomical ref and move 
% them based on the foot posture (11 dof) 
% return the center of the contact spheres in the new posture
%
% INPUT
% x = vector of foot and ankle posture (10X1)
%   x(1:6) represent the pose of the tibia
%   x(7) is the coefficient of the ankle sinergy
%   x(8:10) are the coefficients of the foot sinergies
%   x(11) are the toe flexion 
%
% CS_ana = a structure containing the coordinates of the contact spheres in
%                   the corresponding bone anatomical reference system
%
% SYN = a structure containing the scaled sinergies
%
% OUTPUT
% moved_ana_CS = a vector containing the contact spheres in the actual posture


%tibia
T_TI2G=T_Move2Position_foot([x(1) x(2) x(3) x(4) x(5) x(6)],true);

%ankle
p_ankle=(SYN.u_ankle + x(7)*SYN.v_ankle)';
%foot
p_foot=(SYN.u_foot + x(8)*SYN.v1_foot + x(9)*SYN.v2_foot + x(10)*SYN.v3_foot)';
%toes
p_toes=(SYN.u_toes + x(11)*SYN.v_toes)';

T_TATI = T_Move2Position_foot(p_ankle(1:6),false);
T_FITI = T_Move2Position_foot(p_ankle(7:12),false);
T_CATA = T_Move2Position_foot(p_foot(1:6),false);
T_NATA = T_Move2Position_foot(p_foot(7:12),false);
T_CUNA = T_Move2Position_foot(p_foot(13:18),false);
T_CMNA = T_Move2Position_foot(p_foot(19:24),false);
T_CINA = T_Move2Position_foot(p_foot(25:30),false);
T_CLNA = T_Move2Position_foot(p_foot(31:36),false);
T_M1NA = T_Move2Position_foot(p_foot(37:42),false);
T_M2NA = T_Move2Position_foot(p_foot(43:48),false);
T_M3NA = T_Move2Position_foot(p_foot(49:54),false);
T_M4NA = T_Move2Position_foot(p_foot(55:60),false);
T_M5NA = T_Move2Position_foot(p_foot(61:66),false);
T_T1M1 = T_Move2Position_foot(p_toes(1:6),true);
T_T2M2 = T_Move2Position_foot(p_toes(7:12),true);
T_T3M3 = T_Move2Position_foot(p_toes(13:18),true);
T_T4M4 = T_Move2Position_foot(p_toes(19:24),true);
T_T5M5 = T_Move2Position_foot(p_toes(25:30),true);

T_TA2G = T_TI2G*T_TATI;
T_CA2G = T_TI2G*T_TATI*T_CATA;
T_NA2G = T_TI2G*T_TATI*T_NATA;
T_CU2G = T_TI2G*T_TATI*T_NATA*T_CUNA;
T_CM2G = T_TI2G*T_TATI*T_NATA*T_CMNA;
T_CI2G = T_TI2G*T_TATI*T_NATA*T_CINA;
T_CL2G = T_TI2G*T_TATI*T_NATA*T_CLNA;
T_M12G = T_TI2G*T_TATI*T_NATA*T_M1NA;
T_M22G = T_TI2G*T_TATI*T_NATA*T_M2NA;
T_M32G = T_TI2G*T_TATI*T_NATA*T_M3NA;
T_M42G = T_TI2G*T_TATI*T_NATA*T_M4NA;
T_M52G = T_TI2G*T_TATI*T_NATA*T_M5NA;
T_T12G = T_TI2G*T_TATI*T_NATA*T_M1NA*T_T1M1;
T_T22G = T_TI2G*T_TATI*T_NATA*T_M2NA*T_T2M2;
T_T32G = T_TI2G*T_TATI*T_NATA*T_M3NA*T_T3M3;
T_T42G = T_TI2G*T_TATI*T_NATA*T_M4NA*T_T4M4;
T_T52G = T_TI2G*T_TATI*T_NATA*T_M5NA*T_T5M5;



%move the spheres
moved_ana_CS.TA (1:4) = (T_TA2G*[CS_ana.TA(1:3),1]')';
moved_ana_CS.CAp(1:4) = (T_CA2G*[CS_ana.CAp(1:3),1]')';
moved_ana_CS.CAa(1:4) = (T_CA2G*[CS_ana.CAa(1:3),1]')';
moved_ana_CS.NA (1:4) = (T_NA2G*[CS_ana.NA(1:3),1]')';
moved_ana_CS.CU (1:4) = (T_CU2G*[CS_ana.CU(1:3),1]')';

moved_ana_CS.CMp(1:4) = (T_CM2G*[CS_ana.CMp(1:3),1]')';
moved_ana_CS.CMa(1:4) = (T_CM2G*[CS_ana.CMa(1:3),1]')';
moved_ana_CS.CI (1:4) = (T_CI2G*[CS_ana.CI(1:3),1]')';
moved_ana_CS.CL (1:4) = (T_CL2G*[CS_ana.CL(1:3),1]')';

moved_ana_CS.M1p(1:4) = (T_M12G*[CS_ana.M1p(1:3),1]')';
moved_ana_CS.M1a(1:4) = (T_M12G*[CS_ana.M1a(1:3),1]')';
moved_ana_CS.M2p(1:4) = (T_M22G*[CS_ana.M2p(1:3),1]')';
moved_ana_CS.M2a(1:4) = (T_M22G*[CS_ana.M2a(1:3),1]')';
moved_ana_CS.M3p(1:4) = (T_M32G*[CS_ana.M3p(1:3),1]')';
moved_ana_CS.M3a(1:4) = (T_M32G*[CS_ana.M3a(1:3),1]')';
moved_ana_CS.M4p(1:4) = (T_M42G*[CS_ana.M4p(1:3),1]')';
moved_ana_CS.M4a(1:4) = (T_M42G*[CS_ana.M4a(1:3),1]')';
moved_ana_CS.M5p(1:4) = (T_M52G*[CS_ana.M5p(1:3),1]')';
moved_ana_CS.M5a(1:4) = (T_M52G*[CS_ana.M5a(1:3),1]')';

moved_ana_CS.T1p(1:4) = (T_T12G*[CS_ana.T1p(1:3),1]')';
moved_ana_CS.T1a(1:4) = (T_T12G*[CS_ana.T1a(1:3),1]')';
moved_ana_CS.T2p(1:4) = (T_T22G*[CS_ana.T2p(1:3),1]')';
moved_ana_CS.T2a(1:4) = (T_T22G*[CS_ana.T2a(1:3),1]')';
moved_ana_CS.T3p(1:4) = (T_T32G*[CS_ana.T3p(1:3),1]')';
moved_ana_CS.T3a(1:4) = (T_T32G*[CS_ana.T3a(1:3),1]')';
moved_ana_CS.T4p(1:4) = (T_T42G*[CS_ana.T4p(1:3),1]')';
moved_ana_CS.T4a(1:4) = (T_T42G*[CS_ana.T4a(1:3),1]')';
moved_ana_CS.T5p(1:4) = (T_T52G*[CS_ana.T5p(1:3),1]')';
moved_ana_CS.T5a(1:4) = (T_T52G*[CS_ana.T5a(1:3),1]')';


%save the radius
moved_ana_CS.TA(4)  = CS_ana.TA(4);
moved_ana_CS.CAp(4) = CS_ana.CAp(4);
moved_ana_CS.CAa(4) = CS_ana.CAa(4);
moved_ana_CS.NA(4)  = CS_ana.NA(4);
moved_ana_CS.CU(4)  = CS_ana.CU(4);
moved_ana_CS.CMp(4) = CS_ana.CMp(4);
moved_ana_CS.CMa(4) = CS_ana.CMa(4);
moved_ana_CS.CI(4)  = CS_ana.CI(4);
moved_ana_CS.CL(4)  = CS_ana.CL(4);

moved_ana_CS.M1p(4) = CS_ana.M1p(4);
moved_ana_CS.M1a(4) = CS_ana.M1a(4);
moved_ana_CS.M2p(4) = CS_ana.M2p(4);
moved_ana_CS.M2a(4) = CS_ana.M2a(4);
moved_ana_CS.M3p(4) = CS_ana.M3p(4);
moved_ana_CS.M3a(4) = CS_ana.M3a(4);
moved_ana_CS.M4p(4) = CS_ana.M4p(4);
moved_ana_CS.M4a(4) = CS_ana.M4a(4);
moved_ana_CS.M5p(4) = CS_ana.M5p(4);
moved_ana_CS.M5a(4) = CS_ana.M5a(4);
moved_ana_CS.T1p(4) = CS_ana.T1p(4);
moved_ana_CS.T1a(4) = CS_ana.T1a(4);
moved_ana_CS.T2p(4) = CS_ana.T2p(4);
moved_ana_CS.T2a(4) = CS_ana.T2a(4);
moved_ana_CS.T3p(4) = CS_ana.T3p(4);
moved_ana_CS.T3a(4) = CS_ana.T3a(4);
moved_ana_CS.T4p(4) = CS_ana.T4p(4);
moved_ana_CS.T4a(4) = CS_ana.T4a(4);
moved_ana_CS.T5p(4) = CS_ana.T5p(4);
moved_ana_CS.T5a(4) = CS_ana.T5a(4);
end