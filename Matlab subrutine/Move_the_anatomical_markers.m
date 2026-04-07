function [moved_ana_MK] = Move_the_anatomical_markers(MK_ana,x,SYN)
%the function take a set of anatomical markers and move them based on the foot posture (11 dof) 
% return the markers in the new pose
%
% INPUT
% x = vector of foot and ankle posture (10X1)
%   x(1:6) represent the pose of the tibia
%   x(7) is the coefficient of the ankle sinergy
%   x(8:10) are the coefficients of the foot sinergies
%   x(11) are the toe flexion 
%
% MK_ana = a structure containing the coordinates of the markers in
%                   the corresponding bone anatomical reference system
%
% SYN = a structure containing the scaled sinergies
%
% OUTPUT
% moved_ana_MK = a vector containing the markers in the actual posture


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

% -------------  move each marker -------------
moved_ana_MK.CA=(T_TI2G*T_TATI*T_CATA*MK_ana.CA')';
moved_ana_MK.PT=(T_TI2G*T_TATI*T_CATA*MK_ana.PT')';
moved_ana_MK.ST=(T_TI2G*T_TATI*T_CATA*MK_ana.ST')';
moved_ana_MK.TN=(T_TI2G*T_TATI*T_NATA*MK_ana.TN')';

moved_ana_MK.FMB=(T_TI2G*T_TATI*T_NATA*T_M1NA*MK_ana.FMB')';
moved_ana_MK.FMH=(T_TI2G*T_TATI*T_NATA*T_M1NA*MK_ana.FMH')';
moved_ana_MK.SMB=(T_TI2G*T_TATI*T_NATA*T_M2NA*MK_ana.SMB')';
moved_ana_MK.SMH=(T_TI2G*T_TATI*T_NATA*T_M2NA*MK_ana.SMH')';
moved_ana_MK.VMB=(T_TI2G*T_TATI*T_NATA*T_M5NA*MK_ana.VMB')';
moved_ana_MK.VMH=(T_TI2G*T_TATI*T_NATA*T_M5NA*MK_ana.VMH')';

moved_ana_MK.PM=(T_TI2G*T_TATI*T_NATA*T_M1NA*T_T1M1*MK_ana.PM')';
moved_ana_MK.MM=(T_TI2G*MK_ana.MM')';
moved_ana_MK.LM=(T_TI2G*MK_ana.LM')';
moved_ana_MK.TT=(T_TI2G*MK_ana.TT')';
end

