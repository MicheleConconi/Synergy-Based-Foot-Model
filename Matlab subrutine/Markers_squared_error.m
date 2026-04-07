function [F,marker_error_list] = Markers_squared_error(x,MK_ana,MK_gait,SYN,frame,no_bigtoe)
%the function return the squared errors of the tibia, ankle and foot
%markers
%
% INPUT
% x = vector of foot and ankle posture (10X1)
%   x(1:6) represent the pose of the tibia
%   x(7) is the coefficient of the ankle sinergy
%   x(8:10) are the coefficients of the foot sinergies
%   x(11) are the toe flexion 
%
% marker_in_ana = 11X3 matrix containing the coordinates of the markers in
%                   the corresponding bone anatomical reference system
%
% marker_in_gait = 11X3 matrix containing the coordinates of the markers
%                   measured during the considered motion
%
% SYN = a structure containing the scaled sinergies
%
% OUTPUT
% F = the sum of the squared errors for the considered markers
%
% marker_error_list = a vector containing the squared error of each marker


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

% -------------  evaluate individual marker root errors -------------
err_CA=norm( [MK_gait.CA(frame,:)';1] -T_TI2G*T_TATI*T_CATA*MK_ana.CA')^2;
err_PT=norm( [MK_gait.PT(frame,:)';1] -T_TI2G*T_TATI*T_CATA*MK_ana.PT')^2;
err_ST=norm( [MK_gait.ST(frame,:)';1] -T_TI2G*T_TATI*T_CATA*MK_ana.ST')^2;

err_TN=norm( [MK_gait.TN(frame,:)';1] -T_TI2G*T_TATI*T_NATA*MK_ana.TN')^2;

err_FMB=norm( [MK_gait.FMB(frame,:)';1] -T_TI2G*T_TATI*T_NATA*T_M1NA*MK_ana.FMB')^2;
err_FMH=norm( [MK_gait.FMH(frame,:)';1] -T_TI2G*T_TATI*T_NATA*T_M1NA*MK_ana.FMH')^2;

err_SMB=norm( [MK_gait.SMB(frame,:)';1] -T_TI2G*T_TATI*T_NATA*T_M2NA*MK_ana.SMB')^2;
err_SMH=norm( [MK_gait.SMH(frame,:)';1] -T_TI2G*T_TATI*T_NATA*T_M2NA*MK_ana.SMH')^2;

err_VMB=norm( [MK_gait.VMB(frame,:)';1] -T_TI2G*T_TATI*T_NATA*T_M5NA*MK_ana.VMB')^2;
err_VMH=norm( [MK_gait.VMH(frame,:)';1] -T_TI2G*T_TATI*T_NATA*T_M5NA*MK_ana.VMH')^2;

err_PM=norm( [MK_gait.PM(frame,:)';1] -T_TI2G*T_TATI*T_NATA*T_M1NA*T_T1M1*MK_ana.PM')^2;

err_MM=norm( [MK_gait.MM(frame,:)';1] -T_TI2G*MK_ana.MM')^2;
err_LM=norm( [MK_gait.LM(frame,:)';1] -T_TI2G*MK_ana.LM')^2;
err_TT=norm( [MK_gait.TT(frame,:)';1] -T_TI2G*MK_ana.TT')^2;


% according to which marker errors are considered, different marker set are
% used

marker_error_list = [   err_CA;err_PT;...
    err_ST;...
    err_TN;...
    err_FMB; err_FMH;...
    err_SMB; err_SMH;...
    err_VMB; err_VMH;...
    err_PM;...
    err_MM; err_LM; err_TT];

%ALL MARKERS
if no_bigtoe == true
    tot_err=[err_TT; err_MM; err_LM; err_CA;err_PT;err_ST;err_TN;
             err_FMB; err_FMH; err_SMB; err_SMH; err_VMB; err_VMH];
else 
    tot_err=[err_TT; err_MM; err_LM; err_CA;err_PT;err_ST;err_TN;
             err_FMB; err_FMH; err_SMB; err_SMH; err_VMB; err_VMH;err_PM];

    %4 MARKERS
    % tot_err=[err_TT; err_MM; err_LM; err_CA;
    %     err_FMH; err_SMH; err_VMH;];
    
    %3 MARKERS
    % tot_err=[err_TT; err_MM; err_LM; err_CA;
    %     err_FMH; err_VMH;];
end

F=sum(tot_err);
end

