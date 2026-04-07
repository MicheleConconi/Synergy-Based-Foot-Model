function [P] = Absolute_foot_kinematics_from_synergies(x,SYN,outputfolder,MK_ana)
%Add description
 
[m,n]=size(x);

for s=1:m

    %tibia
    T_TI2G=T_Move2Position_foot([x(s,1) x(s,2) x(s,3) x(s,4) x(s,5) x(s,6)],true);

    %ankle
    p_ankle=(SYN.u_ankle + x(s,7)*SYN.v_ankle)';
    %foot
    p_foot=(SYN.u_foot + x(s,8)*SYN.v1_foot + x(s,9)*SYN.v2_foot + x(s,10)*SYN.v3_foot)';
    %toes
    p_toes=(SYN.u_toes + x(s,11)*SYN.v_toes)';

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


    GeS_TI2G(s,:) = [x(s,1) x(s,2) x(s,3) x(s,4) x(s,5) x(s,6)];

    GeS_TA2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI,false);
    GeS_FI2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_FITI,false);

    GeS_CA2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_CATA,false);
    GeS_NA2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA,false);

    GeS_CU2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_CUNA,false);
    GeS_CM2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_CMNA,false);
    GeS_CI2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_CINA,false);
    GeS_CL2G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_CLNA,false);

    GeS_M12G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M1NA,false);
    GeS_M22G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M2NA,false);
    GeS_M32G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M3NA,false);
    GeS_M42G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M4NA,false);
    GeS_M52G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M5NA,false);

    GeS_T12G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M1NA*T_T1M1,true);
    GeS_T22G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M2NA*T_T2M2,true);
    GeS_T32G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M3NA*T_T3M3,true);
    GeS_T42G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M4NA*T_T4M4,true);
    GeS_T52G(s,:) = GeS_Compute_Coordinates_foot(T_TI2G*T_TATI*T_NATA*T_M5NA*T_T5M5,true);

    P.CA(s,:) = (T_TI2G*T_TATI*T_CATA*MK_ana.CA')';
    P.PT(s,:) = (T_TI2G*T_TATI*T_CATA*MK_ana.PT')';
    P.ST(s,:) = (T_TI2G*T_TATI*T_CATA*MK_ana.ST')';
    P.TN(s,:) = (T_TI2G*T_TATI*T_NATA*MK_ana.TN')';
    P.FMB(s,:) = (T_TI2G*T_TATI*T_NATA*T_M1NA*MK_ana.FMB')';
    P.FMH(s,:) = (T_TI2G*T_TATI*T_NATA*T_M1NA*MK_ana.FMH')';
    P.SMB(s,:) = (T_TI2G*T_TATI*T_NATA*T_M2NA*MK_ana.SMB')';
    P.SMH(s,:) = (T_TI2G*T_TATI*T_NATA*T_M2NA*MK_ana.SMH')';
    P.VMB(s,:) = (T_TI2G*T_TATI*T_NATA*T_M5NA*MK_ana.VMB')';
    P.VMH(s,:) = (T_TI2G*T_TATI*T_NATA*T_M5NA*MK_ana.VMH')';
    P.PM(s,:) = (T_TI2G*T_TATI*T_NATA*T_M1NA*T_T1M1*MK_ana.PM')';
    P.MM(s,:) = (T_TI2G*MK_ana.MM')';
    P.LM(s,:) = (T_TI2G*MK_ana.LM')';
    P.TT(s,:) = (T_TI2G*MK_ana.TT')';
end

% P(1,:)=[];

save([outputfolder 'tib_ana_to_ground.txt'],'GeS_TI2G','-ascii')
save([outputfolder 'tal_ana_to_ground.txt'],'GeS_TA2G','-ascii')
save([outputfolder 'fib_ana_to_ground.txt'],'GeS_FI2G','-ascii')

save([outputfolder 'cal_ana_to_ground.txt'],'GeS_CA2G','-ascii')
save([outputfolder 'sca_ana_to_ground.txt'],'GeS_NA2G','-ascii')

save([outputfolder 'cub_ana_to_ground.txt'],'GeS_CU2G','-ascii')
save([outputfolder 'cme_ana_to_ground.txt'],'GeS_CM2G','-ascii')
save([outputfolder 'cin_ana_to_ground.txt'],'GeS_CI2G','-ascii')
save([outputfolder 'cla_ana_to_ground.txt'],'GeS_CL2G','-ascii')

save([outputfolder 'mt1_ana_to_ground.txt'],'GeS_M12G','-ascii')
save([outputfolder 'mt2_ana_to_ground.txt'],'GeS_M22G','-ascii')
save([outputfolder 'mt3_ana_to_ground.txt'],'GeS_M32G','-ascii')
save([outputfolder 'mt4_ana_to_ground.txt'],'GeS_M42G','-ascii')
save([outputfolder 'mt5_ana_to_ground.txt'],'GeS_M52G','-ascii')

save([outputfolder 't1_ana_to_ground.txt'],'GeS_T12G','-ascii')
save([outputfolder 't2_ana_to_ground.txt'],'GeS_T22G','-ascii')
save([outputfolder 't3_ana_to_ground.txt'],'GeS_T32G','-ascii')
save([outputfolder 't4_ana_to_ground.txt'],'GeS_T42G','-ascii')
save([outputfolder 't5_ana_to_ground.txt'],'GeS_T52G','-ascii')

end