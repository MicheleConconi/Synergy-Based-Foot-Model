function [CS] = Compute_contact_spheres_trajectories(kin_folder,CS_ana)
%given a folder contaning the bone kinematics and file with the contact spheres,
%compute their trajectories. 
%bone kinematics is in GeS (check the convention)

%load the motion
GeS_TA2G = load([kin_folder 'tal_ana_to_ground.txt']);
GeS_CA2G = load([kin_folder 'cal_ana_to_ground.txt']);
GeS_NA2G = load([kin_folder 'sca_ana_to_ground.txt']);
GeS_CU2G = load([kin_folder 'cub_ana_to_ground.txt']);
GeS_CM2G = load([kin_folder 'cme_ana_to_ground.txt']);
GeS_CI2G = load([kin_folder 'cin_ana_to_ground.txt']);
GeS_CL2G = load([kin_folder 'cla_ana_to_ground.txt']);
GeS_M12G = load([kin_folder 'mt1_ana_to_ground.txt']);
GeS_M22G = load([kin_folder 'mt2_ana_to_ground.txt']);
GeS_M32G = load([kin_folder 'mt3_ana_to_ground.txt']);
GeS_M42G = load([kin_folder 'mt4_ana_to_ground.txt']);
GeS_M52G = load([kin_folder 'mt5_ana_to_ground.txt']);
GeS_T12G = load([kin_folder 't1_ana_to_ground.txt']);
GeS_T22G = load([kin_folder 't2_ana_to_ground.txt']);
GeS_T32G = load([kin_folder 't3_ana_to_ground.txt']);
GeS_T42G = load([kin_folder 't4_ana_to_ground.txt']);
GeS_T52G = load([kin_folder 't5_ana_to_ground.txt']);


[m,n]=size(GeS_TA2G);

for s=1:m

    %compute the rototranslational matrixes
    T_TA2G = T_Move2Position_foot(GeS_TA2G(s,:),false);
    T_CA2G = T_Move2Position_foot(GeS_CA2G(s,:),false);
    T_NA2G = T_Move2Position_foot(GeS_NA2G(s,:),false);
    T_CU2G = T_Move2Position_foot(GeS_CU2G(s,:),false);
    T_CM2G = T_Move2Position_foot(GeS_CM2G(s,:),false);
    T_CI2G = T_Move2Position_foot(GeS_CI2G(s,:),false);
    T_CL2G = T_Move2Position_foot(GeS_CL2G(s,:),false);
    T_M12G = T_Move2Position_foot(GeS_M12G(s,:),false);
    T_M22G = T_Move2Position_foot(GeS_M22G(s,:),false);
    T_M32G = T_Move2Position_foot(GeS_M32G(s,:),false);
    T_M42G = T_Move2Position_foot(GeS_M42G(s,:),false);
    T_M52G = T_Move2Position_foot(GeS_M52G(s,:),false);
    T_T12G = T_Move2Position_foot(GeS_T12G(s,:),true);
    T_T22G = T_Move2Position_foot(GeS_T22G(s,:),true);
    T_T32G = T_Move2Position_foot(GeS_T32G(s,:),true);
    T_T42G = T_Move2Position_foot(GeS_T42G(s,:),true);
    T_T52G = T_Move2Position_foot(GeS_T52G(s,:),true);


    %move the spheres
    CS.TA (s,:) = (T_TA2G*[CS_ana.TA(1:3),1]')';
    CS.CAp(s,:) = (T_CA2G*[CS_ana.CAp(1:3),1]')';
    CS.CAa(s,:) = (T_CA2G*[CS_ana.CAa(1:3),1]')';
    CS.NA (s,:) = (T_NA2G*[CS_ana.NA(1:3),1]')';
    CS.CU (s,:) = (T_CU2G*[CS_ana.CU(1:3),1]')';

    CS.CMp(s,:) = (T_CM2G*[CS_ana.CMp(1:3),1]')';
    CS.CMa(s,:) = (T_CM2G*[CS_ana.CMa(1:3),1]')';
    CS.CI (s,:) = (T_CI2G*[CS_ana.CI(1:3),1]')';
    CS.CL (s,:) = (T_CL2G*[CS_ana.CL(1:3),1]')';

    CS.M1p(s,:) = (T_M12G*[CS_ana.M1p(1:3),1]')';
    CS.M1a(s,:) = (T_M12G*[CS_ana.M1a(1:3),1]')';
    CS.M2p(s,:) = (T_M22G*[CS_ana.M2p(1:3),1]')';
    CS.M2a(s,:) = (T_M22G*[CS_ana.M2a(1:3),1]')';
    CS.M3p(s,:) = (T_M32G*[CS_ana.M3p(1:3),1]')';
    CS.M3a(s,:) = (T_M32G*[CS_ana.M3a(1:3),1]')';
    CS.M4p(s,:) = (T_M42G*[CS_ana.M4p(1:3),1]')';
    CS.M4a(s,:) = (T_M42G*[CS_ana.M4a(1:3),1]')';
    CS.M5p(s,:) = (T_M52G*[CS_ana.M5p(1:3),1]')';
    CS.M5a(s,:) = (T_M52G*[CS_ana.M5a(1:3),1]')';

    CS.T1p(s,:) = (T_T12G*[CS_ana.T1p(1:3),1]')';
    CS.T1a(s,:) = (T_T12G*[CS_ana.T1a(1:3),1]')';
    CS.T2p(s,:) = (T_T22G*[CS_ana.T2p(1:3),1]')';
    CS.T2a(s,:) = (T_T22G*[CS_ana.T2a(1:3),1]')';
    CS.T3p(s,:) = (T_T32G*[CS_ana.T3p(1:3),1]')';
    CS.T3a(s,:) = (T_T32G*[CS_ana.T3a(1:3),1]')';
    CS.T4p(s,:) = (T_T42G*[CS_ana.T4p(1:3),1]')';
    CS.T4a(s,:) = (T_T42G*[CS_ana.T4a(1:3),1]')';
    CS.T5p(s,:) = (T_T52G*[CS_ana.T5p(1:3),1]')';
    CS.T5a(s,:) = (T_T52G*[CS_ana.T5a(1:3),1]')';


    %save the radius
    CS.TA(s,4)  = CS_ana.TA(4);
    CS.CAp(s,4) = CS_ana.CAp(4);
    CS.CAa(s,4) = CS_ana.CAa(4);
    CS.NA(s,4)  = CS_ana.NA(4);
    CS.CU(s,4)  = CS_ana.CU(4);
    CS.CMp(s,4) = CS_ana.CMp(4);
    CS.CMa(s,4) = CS_ana.CMa(4);
    CS.CI(s,4)  = CS_ana.CI(4);
    CS.CL(s,4)  = CS_ana.CL(4);

    CS.M1p(s,4) = CS_ana.M1p(4);
    CS.M1a(s,4) = CS_ana.M1a(4);
    CS.M2p(s,4) = CS_ana.M2p(4);
    CS.M2a(s,4) = CS_ana.M2a(4);
    CS.M3p(s,4) = CS_ana.M3p(4);
    CS.M3a(s,4) = CS_ana.M3a(4);
    CS.M4p(s,4) = CS_ana.M4p(4);
    CS.M4a(s,4) = CS_ana.M4a(4);
    CS.M5p(s,4) = CS_ana.M5p(4);
    CS.M5a(s,4) = CS_ana.M5a(4);
    CS.T1p(s,4) = CS_ana.T1p(4);
    CS.T1a(s,4) = CS_ana.T1a(4);
    CS.T2p(s,4) = CS_ana.T2p(4);
    CS.T2a(s,4) = CS_ana.T2a(4);
    CS.T3p(s,4) = CS_ana.T3p(4);
    CS.T3a(s,4) = CS_ana.T3a(4);
    CS.T4p(s,4) = CS_ana.T4p(4);
    CS.T4a(s,4) = CS_ana.T4a(4);
    CS.T5p(s,4) = CS_ana.T5p(4);
    CS.T5a(s,4) = CS_ana.T5a(4);
end