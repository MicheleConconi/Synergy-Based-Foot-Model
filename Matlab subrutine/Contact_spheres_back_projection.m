function [new_CS_ana] = Contact_spheres_back_projection(CS_2b_proj,x,SYN)
%the function take a set of contact spheres in a given posture and retroprojected them
% back in the anatomical reference system of the corresponding bone 
% return the new anatomical contact spheres
%
% INPUT
% x = vector of foot and ankle posture (10X1)
%   x(1:6) represent the pose of the tibia
%   x(7) is the coefficient of the ankle sinergy
%   x(8:10) are the coefficients of the foot sinergies
%   x(11) are the toe flexion 
%
% CS_2b_proj = a structure containing the coordinates of the spheres in
%                   actual posture
%
% SYN = a structure containing the scaled sinergies
%
% OUTPUT
% new_CS_ana = a vector containing the new anatomical sphere set


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

T_G2TA = inv(T_TI2G*T_TATI);
T_G2CA = inv(T_TI2G*T_TATI*T_CATA);
T_G2NA = inv(T_TI2G*T_TATI*T_NATA);
T_G2CU = inv(T_TI2G*T_TATI*T_NATA*T_CUNA);
T_G2CM = inv(T_TI2G*T_TATI*T_NATA*T_CMNA);
T_G2CI = inv(T_TI2G*T_TATI*T_NATA*T_CINA);
T_G2CL = inv(T_TI2G*T_TATI*T_NATA*T_CLNA);
T_G2M1 = inv(T_TI2G*T_TATI*T_NATA*T_M1NA);
T_G2M2 = inv(T_TI2G*T_TATI*T_NATA*T_M2NA);
T_G2M3 = inv(T_TI2G*T_TATI*T_NATA*T_M3NA);
T_G2M4 = inv(T_TI2G*T_TATI*T_NATA*T_M4NA);
T_G2M5 = inv(T_TI2G*T_TATI*T_NATA*T_M5NA);
T_G2T1 = inv(T_TI2G*T_TATI*T_NATA*T_M1NA*T_T1M1);
T_G2T2 = inv(T_TI2G*T_TATI*T_NATA*T_M2NA*T_T2M2);
T_G2T3 = inv(T_TI2G*T_TATI*T_NATA*T_M3NA*T_T3M3);
T_G2T4 = inv(T_TI2G*T_TATI*T_NATA*T_M4NA*T_T4M4);
T_G2T5 = inv(T_TI2G*T_TATI*T_NATA*T_M5NA*T_T5M5);


%move the spheres
new_CS_ana.TA (1:4) = (T_G2TA*[CS_2b_proj.TA(1:3),1]')';
new_CS_ana.CAp(1:4) = (T_G2CA*[CS_2b_proj.CAp(1:3),1]')';
new_CS_ana.CAa(1:4) = (T_G2CA*[CS_2b_proj.CAa(1:3),1]')';
new_CS_ana.NA (1:4) = (T_G2NA*[CS_2b_proj.NA(1:3),1]')';
new_CS_ana.CU (1:4) = (T_G2CU*[CS_2b_proj.CU(1:3),1]')';

new_CS_ana.CMp(1:4) = (T_G2CM*[CS_2b_proj.CMp(1:3),1]')';
new_CS_ana.CMa(1:4) = (T_G2CM*[CS_2b_proj.CMa(1:3),1]')';
new_CS_ana.CI (1:4) = (T_G2CI*[CS_2b_proj.CI(1:3),1]')';
new_CS_ana.CL (1:4) = (T_G2CL*[CS_2b_proj.CL(1:3),1]')';

new_CS_ana.M1p(1:4) = (T_G2M1*[CS_2b_proj.M1p(1:3),1]')';
new_CS_ana.M1a(1:4) = (T_G2M1*[CS_2b_proj.M1a(1:3),1]')';
new_CS_ana.M2p(1:4) = (T_G2M2*[CS_2b_proj.M2p(1:3),1]')';
new_CS_ana.M2a(1:4) = (T_G2M2*[CS_2b_proj.M2a(1:3),1]')';
new_CS_ana.M3p(1:4) = (T_G2M3*[CS_2b_proj.M3p(1:3),1]')';
new_CS_ana.M3a(1:4) = (T_G2M3*[CS_2b_proj.M3a(1:3),1]')';
new_CS_ana.M4p(1:4) = (T_G2M4*[CS_2b_proj.M4p(1:3),1]')';
new_CS_ana.M4a(1:4) = (T_G2M4*[CS_2b_proj.M4a(1:3),1]')';
new_CS_ana.M5p(1:4) = (T_G2M5*[CS_2b_proj.M5p(1:3),1]')';
new_CS_ana.M5a(1:4) = (T_G2M5*[CS_2b_proj.M5a(1:3),1]')';

new_CS_ana.T1p(1:4) = (T_G2T1*[CS_2b_proj.T1p(1:3),1]')';
new_CS_ana.T1a(1:4) = (T_G2T1*[CS_2b_proj.T1a(1:3),1]')';
new_CS_ana.T2p(1:4) = (T_G2T2*[CS_2b_proj.T2p(1:3),1]')';
new_CS_ana.T2a(1:4) = (T_G2T2*[CS_2b_proj.T2a(1:3),1]')';
new_CS_ana.T3p(1:4) = (T_G2T3*[CS_2b_proj.T3p(1:3),1]')';
new_CS_ana.T3a(1:4) = (T_G2T3*[CS_2b_proj.T3a(1:3),1]')';
new_CS_ana.T4p(1:4) = (T_G2T4*[CS_2b_proj.T4p(1:3),1]')';
new_CS_ana.T4a(1:4) = (T_G2T4*[CS_2b_proj.T4a(1:3),1]')';
new_CS_ana.T5p(1:4) = (T_G2T5*[CS_2b_proj.T5p(1:3),1]')';
new_CS_ana.T5a(1:4) = (T_G2T5*[CS_2b_proj.T5a(1:3),1]')';


%save the radius
new_CS_ana.TA(4)  = CS_2b_proj.TA(4);
new_CS_ana.CAp(4) = CS_2b_proj.CAp(4);
new_CS_ana.CAa(4) = CS_2b_proj.CAa(4);
new_CS_ana.NA(4)  = CS_2b_proj.NA(4);
new_CS_ana.CU(4)  = CS_2b_proj.CU(4);
new_CS_ana.CMp(4) = CS_2b_proj.CMp(4);
new_CS_ana.CMa(4) = CS_2b_proj.CMa(4);
new_CS_ana.CI(4)  = CS_2b_proj.CI(4);
new_CS_ana.CL(4)  = CS_2b_proj.CL(4);

new_CS_ana.M1p(4) = CS_2b_proj.M1p(4);
new_CS_ana.M1a(4) = CS_2b_proj.M1a(4);
new_CS_ana.M2p(4) = CS_2b_proj.M2p(4);
new_CS_ana.M2a(4) = CS_2b_proj.M2a(4);
new_CS_ana.M3p(4) = CS_2b_proj.M3p(4);
new_CS_ana.M3a(4) = CS_2b_proj.M3a(4);
new_CS_ana.M4p(4) = CS_2b_proj.M4p(4);
new_CS_ana.M4a(4) = CS_2b_proj.M4a(4);
new_CS_ana.M5p(4) = CS_2b_proj.M5p(4);
new_CS_ana.M5a(4) = CS_2b_proj.M5a(4);
new_CS_ana.T1p(4) = CS_2b_proj.T1p(4);
new_CS_ana.T1a(4) = CS_2b_proj.T1a(4);
new_CS_ana.T2p(4) = CS_2b_proj.T2p(4);
new_CS_ana.T2a(4) = CS_2b_proj.T2a(4);
new_CS_ana.T3p(4) = CS_2b_proj.T3p(4);
new_CS_ana.T3a(4) = CS_2b_proj.T3a(4);
new_CS_ana.T4p(4) = CS_2b_proj.T4p(4);
new_CS_ana.T4a(4) = CS_2b_proj.T4a(4);
new_CS_ana.T5p(4) = CS_2b_proj.T5p(4);
new_CS_ana.T5a(4) = CS_2b_proj.T5a(4);
end