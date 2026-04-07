function [scaled_SYN]=scale_foot_and_ankle_sinergies(param)
% This function scale anisotropically the synergies associated with the
% foot and ankle. The toes are scaled separatly

% param.in_folder = in_folder;
% param.side = side;
% param.out_folder = out_folder;
% param.SYN = SYN;
% param.scaled_SYN = scaled_SYN;
% param.x = x;
% param.T_tib_scaling = T_tib_scaling;
% param.T_foot_scaling = T_foot_scaling;
% param.T_thumb_scaling = T_thumb_scaling;

SYN = param.SYN;
scaled_SYN = SYN;
T_ts = eye(4);
T_fs = eye(4);

T_ts(1:3,1:3) = param.T_tib_scaling;
T_fs(1:3,1:3) = param.T_foot_scaling;


% compute the matrixes from anatomical ref to average foot posture, in TI
% reference system

%ankle
p_ankle=(SYN.u_ankle)';
%foot
p_foot=(SYN.u_foot)';


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

T_CU2TA = T_NATA*T_CUNA;
T_CM2TA = T_NATA*T_CMNA;
T_CI2TA = T_NATA*T_CINA;
T_CL2TA = T_NATA*T_CLNA;
T_M12TA = T_NATA*T_M1NA;
T_M22TA = T_NATA*T_M2NA;
T_M32TA = T_NATA*T_M3NA;
T_M42TA = T_NATA*T_M4NA;
T_M52TA = T_NATA*T_M5NA;



% compute the scaled origin of all the reference systems 
% TA and FI are expressed in the tibia ref and thus can be directly scaled
TA_so = T_ts*T_TATI(:,4);
FI_so = T_ts*T_FITI(:,4);

scaled_SYN.u_ankle(4:6)   = TA_so(1:3)';
scaled_SYN.u_ankle(10:12) = FI_so(1:3)';

for k=4:6:12
    scaled_SYN.v_ankle(k:k+2)=mean(diag(param.T_tib_scaling))*SYN.v_ankle(k:k+2);
end

% the rest of the foot bones need to be scaled in the talus ref
% CA and NA are expressed in the talus ref and thus can be directly scaled.
% the remaining origin have to be scaled in TA and then expressed in NA scaled
% the same is true for the toes, which are the first connection with the
% foot, so similar to the talus, need to be scaled in place wrt the distal
% segment, but then expressed relative to the corresponding metatarsal
CA_so = T_fs*T_CATA(:,4);
NA_so = T_fs*T_NATA(:,4);

T_NATA_so = T_NATA;
T_NATA_so(:,4)=NA_so;

CU_so = inv(T_NATA_so)*T_fs*T_CU2TA(:,4);
CM_so = inv(T_NATA_so)*T_fs*T_CM2TA(:,4);
CI_so = inv(T_NATA_so)*T_fs*T_CI2TA(:,4);
CL_so = inv(T_NATA_so)*T_fs*T_CL2TA(:,4);
M1_so = inv(T_NATA_so)*T_fs*T_M12TA(:,4);
M2_so = inv(T_NATA_so)*T_fs*T_M22TA(:,4);
M3_so = inv(T_NATA_so)*T_fs*T_M32TA(:,4);
M4_so = inv(T_NATA_so)*T_fs*T_M42TA(:,4);
M5_so = inv(T_NATA_so)*T_fs*T_M52TA(:,4);

scaled_SYN.u_foot(4:6)   = CA_so(1:3)';
scaled_SYN.u_foot(10:12) = NA_so(1:3)';
scaled_SYN.u_foot(16:18) = CU_so(1:3)';
scaled_SYN.u_foot(22:24) = CM_so(1:3)';
scaled_SYN.u_foot(28:30) = CI_so(1:3)';
scaled_SYN.u_foot(34:36) = CL_so(1:3)';
scaled_SYN.u_foot(40:42) = M1_so(1:3)';
scaled_SYN.u_foot(46:48) = M2_so(1:3)';
scaled_SYN.u_foot(52:54) = M3_so(1:3)';
scaled_SYN.u_foot(58:60) = M4_so(1:3)';
scaled_SYN.u_foot(64:66) = M5_so(1:3)';

for k=4:6:66
    scaled_SYN.v1_foot(k:k+2)=mean(diag(param.T_foot_scaling))*SYN.v1_foot(k:k+2);
    scaled_SYN.v2_foot(k:k+2)=mean(diag(param.T_foot_scaling))*SYN.v2_foot(k:k+2);
    scaled_SYN.v3_foot(k:k+2)=mean(diag(param.T_foot_scaling))*SYN.v3_foot(k:k+2);
end


end