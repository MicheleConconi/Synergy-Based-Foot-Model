function []=scaled_and_save_bone_STL(param)
% This function scale anisotropically all the bone STL files

% param.in_folder = in_folder;
% param.side = side;
% param.out_folder = out_folder;
% param.SYN = SYN;
% param.scaled_SYN = scaled_SYN;
% param.x = x;
% param.T_scaling = T_scaling;

SYN = param.SYN;
scaled_SYN = param.scaled_SYN;

T_ts = eye(4);
T_fs = eye(4);
T_th = eye(4);

T_ts(1:3,1:3) = param.T_tib_scaling;
T_fs(1:3,1:3) = param.T_foot_scaling;
T_th(1:3,1:3) = param.T_thumb_scaling;

% compute the matrixes from anatomical ref to average foot posture
%tibia
T_TI2G=eye(4);
%ankle
p_ankle=(SYN.u_ankle)';
%foot
p_foot=(SYN.u_foot)';
%toes
p_toes=(SYN.u_toes)';

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
T_FI2G = T_TI2G*T_FITI;
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

% compute the matrixes from the average foot posture to the anisotropically
% scaled anatomical ref

%tibia
T_TI2G_scaled=eye(4);
%ankle
p_ankle_scaled=(scaled_SYN.u_ankle)';
%foot
p_foot_scaled=(scaled_SYN.u_foot)';
%toes
p_toes_scaled=(scaled_SYN.u_toes)';

T_TATI_scaled = T_Move2Position_foot(p_ankle_scaled(1:6),false);
T_FITI_scaled = T_Move2Position_foot(p_ankle_scaled(7:12),false);
T_CATA_scaled = T_Move2Position_foot(p_foot_scaled(1:6),false);
T_NATA_scaled = T_Move2Position_foot(p_foot_scaled(7:12),false);
T_CUNA_scaled = T_Move2Position_foot(p_foot_scaled(13:18),false);
T_CMNA_scaled = T_Move2Position_foot(p_foot_scaled(19:24),false);
T_CINA_scaled = T_Move2Position_foot(p_foot_scaled(25:30),false);
T_CLNA_scaled = T_Move2Position_foot(p_foot_scaled(31:36),false);
T_M1NA_scaled = T_Move2Position_foot(p_foot_scaled(37:42),false);
T_M2NA_scaled = T_Move2Position_foot(p_foot_scaled(43:48),false);
T_M3NA_scaled = T_Move2Position_foot(p_foot_scaled(49:54),false);
T_M4NA_scaled = T_Move2Position_foot(p_foot_scaled(55:60),false);
T_M5NA_scaled = T_Move2Position_foot(p_foot_scaled(61:66),false);
T_T1M1_scaled = T_Move2Position_foot(p_toes_scaled(1:6),true);
T_T2M2_scaled = T_Move2Position_foot(p_toes_scaled(7:12),true);
T_T3M3_scaled = T_Move2Position_foot(p_toes_scaled(13:18),true);
T_T4M4_scaled = T_Move2Position_foot(p_toes_scaled(19:24),true);
T_T5M5_scaled = T_Move2Position_foot(p_toes_scaled(25:30),true);

T_TA2G_scaled = T_TI2G_scaled*T_TATI_scaled;
T_FI2G_scaled = T_TI2G_scaled*T_FITI_scaled;
T_CA2G_scaled = T_TI2G_scaled*T_TATI_scaled*T_CATA_scaled;
T_NA2G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled;
T_CU2G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_CUNA_scaled;
T_CM2G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_CMNA_scaled;
T_CI2G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_CINA_scaled;
T_CL2G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_CLNA_scaled;
T_M12G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M1NA_scaled;
T_M22G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M2NA_scaled;
T_M32G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M3NA_scaled;
T_M42G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M4NA_scaled;
T_M52G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M5NA_scaled;
T_T12G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M1NA_scaled*T_T1M1_scaled;
T_T22G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M2NA_scaled*T_T2M2_scaled;
T_T32G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M3NA_scaled*T_T3M3_scaled;
T_T42G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M4NA_scaled*T_T4M4_scaled;
T_T52G_scaled = T_TI2G_scaled*T_TATI_scaled*T_NATA_scaled*T_M5NA_scaled*T_T5M5_scaled;

% % compute the final transformation matrixes
% T_final(1,:,:) =inv(T_TI2G_scaled)*T_ts*T_TI2G;
% T_final(2,:,:) =inv(T_TA2G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_TA2G;
% T_final(3,:,:) =inv(T_FI2G_scaled)*T_TI2G*T_ts*inv(T_TI2G)*T_FI2G;
% T_final(4,:,:) =inv(T_CA2G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_CA2G;
% T_final(5,:,:) =inv(T_NA2G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_NA2G;
% T_final(6,:,:) =inv(T_CU2G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_CU2G;
% T_final(7,:,:) =inv(T_CM2G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_CM2G;
% T_final(8,:,:) =inv(T_CI2G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_CI2G;
% T_final(9,:,:) =inv(T_CL2G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_CL2G;
% T_final(10,:,:) =inv(T_M12G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_M12G;
% T_final(11,:,:) =inv(T_M22G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_M22G;
% T_final(12,:,:) =inv(T_M32G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_M32G;
% T_final(13,:,:) =inv(T_M42G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_M42G;
% T_final(14,:,:) =inv(T_M52G_scaled)*T_TA2G*T_fs*inv(T_TA2G)*T_M52G;
% T_final(15,:,:) =inv(T_T12G_scaled)*T_M12G*T_th*inv(T_M12G)*T_T12G;
% T_final(16,:,:) =inv(T_T22G_scaled)*T_M22G*T_th*inv(T_M22G)*T_T22G;
% T_final(17,:,:) =inv(T_T32G_scaled)*T_M32G*T_th*inv(T_M32G)*T_T32G;
% T_final(18,:,:) =inv(T_T42G_scaled)*T_M42G*T_th*inv(T_M42G)*T_T42G;
% T_final(19,:,:) =inv(T_T52G_scaled)*T_M52G*T_th*inv(T_M52G)*T_T52G;

% compute the final transformation matrixes
T_final(1,:,:) =T_ts; % TI
T_final(2,:,:) =T_fs; % TA
T_final(3,:,:) =inv(T_FITI_scaled)*T_TI2G*T_ts*T_FITI;
T_final(4,:,:) =inv(T_CA2G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_CA2G;
T_final(5,:,:) =inv(T_NA2G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_NA2G;
T_final(6,:,:) =inv(T_CU2G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_CU2G;
T_final(7,:,:) =inv(T_CM2G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_CM2G;
T_final(8,:,:) =inv(T_CI2G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_CI2G;
T_final(9,:,:) =inv(T_CL2G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_CL2G;
T_final(10,:,:) =inv(T_M12G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_M12G;
T_final(11,:,:) =inv(T_M22G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_M22G;
T_final(12,:,:) =inv(T_M32G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_M32G;
T_final(13,:,:) =inv(T_M42G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_M42G;
T_final(14,:,:) =inv(T_M52G_scaled)*T_TA2G_scaled*T_fs*inv(T_TA2G)*T_M52G;
T_final(15,:,:) =T_th;
T_final(16,:,:) =T_th;
T_final(17,:,:) =T_th;
T_final(18,:,:) =T_th;
T_final(19,:,:) =T_th;


% move and save all the STL
bones = char('TI','TA','FI','CA','NA','CU','CM','CI','CL',...
            'M1','M2','M3','M4','M5',...
            'T1','T2','T3','T4','T5');

[m,n] = size (bones);

for I = 1:m
    fprintf(['converting ' bones(I,:) '\n'])
    clear input_stl output_stl
    input_stl = char( [param.in_folder param.side '\Bones in ana\' bones(I,:) '_ana.stl']);
    output_stl = char( [param.out_folder param.side '\Bones in ana\' bones(I,:) '_ana.stl']);
    T(1:4,1:4) = T_final(I,:,:);
    transform_stl(input_stl, output_stl, T);
    fprintf('---- done ----- \n')
end

end