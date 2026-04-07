% SYNERGY-BASED MULTYBODY KINEMATIC OPTIMIZATION (SB-MKO) FOR THE FOOT -
% Anysotropic scaling

% Code by Michele Conconi, University of Bologna, 2026


% The code scale all the model parmeters that will be used to reconstruct 
% the foot kinematics from gait data exploiting foot synergies, based on:

% Conconi, M., Sancisi, N., Leardini, A., & Belvedere, C. (2024). The foot 
% and ankle complex as a four degrees‐of‐freedom system: Kinematic coupling 
% among the foot bones. Journal of Orthopaedic Research.

% ------------------- INPUT ---------------------
% The code take as an input a .trc file describing the coordinates of the
% foot marker in a static trial, in which the subjected is stending still, 
% and the side (left - L, or right - R) to be scaled.

% Relevant markers and their name must defined according to the Rizzoli foot 
% marker set proposed in

% Leardini, A., Benedetti, M. G., Berti, L., Bettinelli, D., Nativo, R., & Giannini, S. (2007). 
% Rear-foot, mid-foot and fore-foot motion during the stance phase of gait. Gait & posture, 
% 25(3), 453-462.

% and can be reassumed as
% CA PT ST (in CA)
% TN (in NA)
% FMB FMH (in M1)
% SMB SMH (in M2)
% VMB VMH (in M5)
% PM (in T1)
% MM LM TT (in TI)

% The code also assumes to be having access to the subfolder "Generic
% model", which contains all the data for the right (R) and left (L) foot.



% -------------------- OUTPUT --------------------------
% The code will compute:
% - the scaled foot an ankle synergies
% - a new set of anatomical markers, resulting from backprojection of
% experimental ones after scaling and fitting the model on the static trial
% - the scaled foot contact spheres
% - scaled stl files of the bones
% - all the model info will be saved in the folder "Scaled model"



%% ---------- Read data and set parameters --------------------------
clear all
clc

% set the folder for data and input
static_trial = char('motion data\static.trc'); %where the .trc static file is
side = 'R'; %select the leg that we want to build the model for
Units = 'm'; %coordinate can be expressed in meter (m), or millimeter (mm)

generic_model_folder = char('Generic model\');
out_folder = char('Scaled model\');

%set toes adjusting based on static pose
toes_adjusting = true; % if true, it applies a correciton of the toes alignment based on the static pose

addpath('.\Matlab subrutine\');

%% ----------- load the static trial --------------
% trc = readTRC(static_trial);

load("C:\Users\michele.conconi3\OneDrive - Alma Mater Studiorum Università di Bologna\Arthrone_Legs\Desktop\Synergy based MKO - anisotropic scaling\motion data\999999m018\20181024\Right\export_Michele\24102018_999999m018_PAD_Dyn_Right_03.mat")
MK_static = marker_italy.stat;
MK_dynamic = marker_italy.dyn;
Units = 'm';
side = 'R';

%loading all the files to be scaled: marker in ana, contact spheres in ana,
%synergies

load([generic_model_folder side '\Bones in ana\MK_ana.mat']);
load([generic_model_folder side '\Bones in ana\CS_ana.mat']);

SYN.u_ankle = load([generic_model_folder side '\Synergies\u_ankle_mean.txt']);
SYN.v_ankle = load([generic_model_folder side '\Synergies\v_ankle_mean.txt']);

SYN.u_foot = load([generic_model_folder side '\Synergies\u_foot_mean.txt']);
V = load([generic_model_folder side '\Synergies\v_foot_mean.txt']);
SYN.v1_foot = V(:,1);
SYN.v2_foot = V(:,2);
SYN.v3_foot = V(:,3);

SYN.u_toes = load([generic_model_folder side '\Synergies\u_toes.txt']);
SYN.v_toes = load([generic_model_folder side '\Synergies\v_toes.txt']);


% converts experimental data in mm
if Units == 'm'
    UnitConversion = 1000;
elseif Units == 'mm'
    UnitConversion = 1; 
end

MK_static.TT=  marker_italy.stat.TT*UnitConversion;
MK_static.LM=  marker_italy.stat.LM*UnitConversion;
MK_static.MM=  marker_italy.stat.MM*UnitConversion;
MK_static.CA=  marker_italy.stat.CA*UnitConversion;
MK_static.PT=  marker_italy.stat.PT*UnitConversion;
MK_static.ST=  marker_italy.stat.ST*UnitConversion;
MK_static.VMB= marker_italy.stat.VMB*UnitConversion;
MK_static.TN=  marker_italy.stat.TN*UnitConversion;
MK_static.SMB= marker_italy.stat.SMB*UnitConversion;
MK_static.FMB= marker_italy.stat.FMB*UnitConversion;
MK_static.VMH= marker_italy.stat.VMH*UnitConversion;
MK_static.SMH= marker_italy.stat.SMH*UnitConversion;
MK_static.FMH= marker_italy.stat.FMH*UnitConversion;
MK_static.PM=  marker_italy.stat.PM*UnitConversion;

% if side == 'R'
%     MK_static.TT=  trc.Data.RTT*UnitConversion;
%     MK_static.LM=  trc.Data.RLM*UnitConversion;
%     MK_static.MM=  trc.Data.RMM*UnitConversion;
%     MK_static.CA=  trc.Data.RCA*UnitConversion;
%     MK_static.PT=  trc.Data.RPT*UnitConversion;
%     MK_static.ST=  trc.Data.RST*UnitConversion;
%     MK_static.VMB= trc.Data.RVMB*UnitConversion;
%     MK_static.TN=  trc.Data.RTN*UnitConversion;
%     MK_static.SMB= trc.Data.RSMB*UnitConversion;
%     MK_static.FMB= trc.Data.RFMB*UnitConversion;
%     MK_static.VMH= trc.Data.RVMH*UnitConversion;
%     MK_static.SMH= trc.Data.RSMH*UnitConversion;
%     MK_static.FMH= trc.Data.RFMH*UnitConversion;
%     MK_static.PM=  trc.Data.RPM*UnitConversion;
% else
%     MK_static.TT=  trc.Data.LTT*UnitConversion;
%     MK_static.LM=  trc.Data.LLM*UnitConversion;
%     MK_static.MM=  trc.Data.LMM*UnitConversion;
%     MK_static.CA=  trc.Data.LCA*UnitConversion;
%     MK_static.PT=  trc.Data.LPT*UnitConversion;
%     MK_static.ST=  trc.Data.LST*UnitConversion;
%     MK_static.VMB= trc.Data.LVMB*UnitConversion;
%     MK_static.TN=  trc.Data.LTN*UnitConversion;
%     MK_static.SMB= trc.Data.LSMB*UnitConversion;
%     MK_static.FMB= trc.Data.LFMB*UnitConversion;
%     MK_static.VMH= trc.Data.LVMH*UnitConversion;
%     MK_static.SMH= trc.Data.LSMH*UnitConversion;
%     MK_static.FMH= trc.Data.LFMH*UnitConversion;
%     MK_static.PM=  trc.Data.LPM*UnitConversion;
% end

% we assume that the average foot posture can be close enough to the
% neutral one to be used for scaling
% evaluate the location of the anatomical marker in the average foot
% posture, as well as contact spheres location
x = [0,0,0,0,0,0,0,0,0,0,0];
MK_average_posture = Move_the_anatomical_markers(MK_ana,x,SYN);
CS_average_posture = Move_the_anatomical_contact_spheres(CS_ana,x,SYN)


% ----------- tibia scaling factor --------------
%the anatomical reference system of the tibia is with x anterior, y
%proximal, and z to the right
%the average foot posture follow the same alignement

D1 = norm(mean(MK_static.MM-MK_static.LM));
D2 = norm(mean(MK_static.LM-MK_static.TT));
D3 = norm(mean(MK_static.LM-MK_static.MM));

d1 = norm(MK_average_posture.MM-MK_average_posture.LM);
d2 = norm(MK_average_posture.LM-MK_average_posture.TT);
d3 = norm(MK_average_posture.LM-MK_average_posture.MM);

Y_tib_scaling = (D1/d1+D2/d2)/2
Z_tib_scaling = D3/d3
X_tib_scaling = (Y_tib_scaling + Z_tib_scaling)/2

T_tib_scaling = diag([X_tib_scaling,Y_tib_scaling,Z_tib_scaling]);


% ---------- foot scaling factor ---------------------
D4 = norm(mean(MK_static.FMH-MK_static.CA));
D5 = norm(mean(MK_static.VMH-MK_static.CA));
D6 = norm(mean(MK_static.FMH-MK_static.VMH));

x1 = mean(MK_static.FMH-MK_static.CA);
x2 = mean(MK_static.VMH-MK_static.CA);
if side == 'R'
    contact_plane_normal = cross(x2,x1);
else
    contact_plane_normal = cross(x1,x2);
end
contact_plane_normal = contact_plane_normal/norm(contact_plane_normal);

D7 = norm(mean(MK_static.MM-MK_static.CA)*contact_plane_normal');
D8 = norm(mean(MK_static.LM-MK_static.CA)*contact_plane_normal');


d4 = norm(MK_average_posture.FMH-MK_average_posture.CA);
d5 = norm(MK_average_posture.VMH-MK_average_posture.CA);
d6 = norm(MK_average_posture.FMH-MK_average_posture.VMH);

x1 = MK_average_posture.FMH-MK_average_posture.CA;
x2 = MK_average_posture.VMH-MK_average_posture.CA;
if side == 'R'
    contact_plane_normal = cross(x2(1:3),x1(1:3));
else
    contact_plane_normal = cross(x1(1:3),x2(1:3));
end
contact_plane_normal = contact_plane_normal/norm(contact_plane_normal);
d7 = norm((MK_average_posture.MM(1:3)-MK_average_posture.CA(1:3))*contact_plane_normal');
d8 = norm((MK_average_posture.LM(1:3)-MK_average_posture.CA(1:3))*contact_plane_normal');

X_foot_scaling = (D4/d4+D5/d5)/2
Y_foot_scaling = (D7/d7+D8/d8)/2
Z_foot_scaling = D6/d6

T_foot_scaling = diag([X_foot_scaling,Y_foot_scaling,Z_foot_scaling]);

% scaling the markers in the average posture and project them back in the
% anatomical reference system, using the scaled sinergies.
% as we have different scaling factor, we need to set the scaling center
% the tibia is already at its anatomical reference system.
% the foot need to be scaled based on the talus ref
% the thumb scaling is based on marker that are on two different segment: 
% the foot(FMH) and the toes (PT).

%ankle
p_ankle=(SYN.u_ankle)';

T_TATI = T_Move2Position_foot(p_ankle(1:6),false);

T_foot_scal_origin = eye(4);
T_foot_scal_origin(1:3,4) = T_TATI(1:3,4)';

T_tib_scaling4x4 = [T_tib_scaling,[0 0 0]';[0,0,0,1]];
T_foot_scaling4x4 = [T_foot_scaling,[0 0 0]';[0,0,0,1]];

MK_average_posture_scaled=MK_average_posture;

MK_average_posture_scaled.CA  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.CA')';
MK_average_posture_scaled.PT  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.PT')';
MK_average_posture_scaled.ST  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.ST')';
MK_average_posture_scaled.TN  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.TN')'; 
MK_average_posture_scaled.FMB = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.FMB')';
MK_average_posture_scaled.FMH = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.FMH')';
MK_average_posture_scaled.SMB = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.SMB')';
MK_average_posture_scaled.SMH = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.SMH')';
MK_average_posture_scaled.VMB = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.VMB')';
MK_average_posture_scaled.VMH = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*MK_average_posture.VMH')';
MK_average_posture_scaled.MM  = (T_tib_scaling4x4*MK_average_posture.MM')';
MK_average_posture_scaled.LM  = (T_tib_scaling4x4*MK_average_posture.LM')';
MK_average_posture_scaled.TT  = (T_tib_scaling4x4*MK_average_posture.TT')';


% scaling the contact spheres in the average posture and project them back in the
% anatomical reference system, using the scaled sinergies

% set the radius to 1 to use it as homegeneus coordinates of sphere centers
CS_avg_names = fieldnames(CS_average_posture);   
for k = 1:numel(CS_avg_names)
    cs_avg = CS_avg_names{k};
    CS_average_posture.(cs_avg)(4)=1;
end
CS_average_posture_scaled=CS_average_posture;

%scale anisotropically the foot contact spheres centers wrt the talus origin
CS_average_posture_scaled.TA  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.TA')';
CS_average_posture_scaled.CAp = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.CAp')';
CS_average_posture_scaled.CAa = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.CAa')';
CS_average_posture_scaled.NA  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.NA')';
CS_average_posture_scaled.CU  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.CU')';
CS_average_posture_scaled.CMp = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.CMp')';
CS_average_posture_scaled.CMa = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.CMa')';
CS_average_posture_scaled.CI  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.CI')';
CS_average_posture_scaled.CL  = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.CL')';
CS_average_posture_scaled.M1p = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M1p')';
CS_average_posture_scaled.M1a = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M1a')';
CS_average_posture_scaled.M2p = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M2p')';
CS_average_posture_scaled.M2a = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M2a')';
CS_average_posture_scaled.M3p = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M3p')';
CS_average_posture_scaled.M3a = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M3a')';
CS_average_posture_scaled.M4p = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M4p')';
CS_average_posture_scaled.M4a = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M4a')';
CS_average_posture_scaled.M5p = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M5p')';
CS_average_posture_scaled.M5a = (T_foot_scal_origin*T_foot_scaling4x4*inv(T_foot_scal_origin)*CS_average_posture.M5a')';


%scale the radius
CS_average_posture_scaled.TA  (4) = mean(diag(T_foot_scaling))*CS_ana.TA(4);
CS_average_posture_scaled.CAp (4) = mean(diag(T_foot_scaling))*CS_ana.CAp(4);
CS_average_posture_scaled.CAa (4) = mean(diag(T_foot_scaling))*CS_ana.CAa(4);
CS_average_posture_scaled.NA  (4) = mean(diag(T_foot_scaling))*CS_ana.NA(4);
CS_average_posture_scaled.CU  (4) = mean(diag(T_foot_scaling))*CS_ana.CU(4);
CS_average_posture_scaled.CMp (4) = mean(diag(T_foot_scaling))*CS_ana.CMp(4);
CS_average_posture_scaled.CMa (4) = mean(diag(T_foot_scaling))*CS_ana.CMa(4);
CS_average_posture_scaled.CI  (4) = mean(diag(T_foot_scaling))*CS_ana.CI(4);
CS_average_posture_scaled.CL  (4) = mean(diag(T_foot_scaling))*CS_ana.CL(4);
CS_average_posture_scaled.M1p (4) = mean(diag(T_foot_scaling))*CS_ana.M1p(4);
CS_average_posture_scaled.M1a (4) = mean(diag(T_foot_scaling))*CS_ana.M1a(4);
CS_average_posture_scaled.M2p (4) = mean(diag(T_foot_scaling))*CS_ana.M2p(4);
CS_average_posture_scaled.M2a (4) = mean(diag(T_foot_scaling))*CS_ana.M2a(4);
CS_average_posture_scaled.M3p (4) = mean(diag(T_foot_scaling))*CS_ana.M3p(4);
CS_average_posture_scaled.M3a (4) = mean(diag(T_foot_scaling))*CS_ana.M3a(4);
CS_average_posture_scaled.M4p (4) = mean(diag(T_foot_scaling))*CS_ana.M4p(4);
CS_average_posture_scaled.M4a (4) = mean(diag(T_foot_scaling))*CS_ana.M4a(4);
CS_average_posture_scaled.M5p (4) = mean(diag(T_foot_scaling))*CS_ana.M5p(4);
CS_average_posture_scaled.M5a (4) = mean(diag(T_foot_scaling))*CS_ana.M5a(4);


%scale and save the synergies

%create a structure to pass all the data
param.in_folder = generic_model_folder;
param.side = side;
param.out_folder = out_folder;
param.SYN = SYN;
param.T_tib_scaling = T_tib_scaling;
param.T_foot_scaling = T_foot_scaling;
param.T_thumb_scaling = eye(4);

scaled_SYN = scale_foot_and_ankle_sinergies(param);

scaled_MK_ana = Marker_back_projection(MK_average_posture_scaled,x,scaled_SYN);
scaled_CS_ana = Contact_spheres_back_projection(CS_average_posture_scaled,x,scaled_SYN);


%The toes parameter need to be scaled after the foot
scaled_MK_ana.PM = MK_ana.PM;

CS_average_posture_scaled.T1p= CS_average_posture.T1p;
CS_average_posture_scaled.T1a= CS_average_posture.T1a;
CS_average_posture_scaled.T2p= CS_average_posture.T2p;
CS_average_posture_scaled.T2a= CS_average_posture.T2a;
CS_average_posture_scaled.T3p= CS_average_posture.T3p;
CS_average_posture_scaled.T3a= CS_average_posture.T3a;
CS_average_posture_scaled.T4p= CS_average_posture.T4p;
CS_average_posture_scaled.T4a= CS_average_posture.T4a;
CS_average_posture_scaled.T5p= CS_average_posture.T5p;
CS_average_posture_scaled.T5a= CS_average_posture.T5a;

% As we have one single marker on the big toe, the scaling of the toes is 
% is performed based on the distance of it wrt to the big toe reference 
% systems origin. The% location of the experimental maker depend however on 
% the foot scaling, that need thus to be perfomed prior to this step, and to
% the SB-MKO fitting of the model on the static trial.
[m,n] = size(MK_static.CA);

x_opt=[];
x_opt_i = [0,0,0,0,0,0,0,0,0,0,0]';

for is = 1:m
    is/m*100 %processing percentage
    % inizialitation
    marker_in_tib_ana_ref=[scaled_MK_ana.MM;scaled_MK_ana.LM;scaled_MK_ana.TT];
    marker_in_tib_ana_ref=marker_in_tib_ana_ref';
    
    x_opt_i = [0,0,0,0,0,0,0,0,0,0,0]';
    
    % prepare data for the inizialization of the tibia pose
    marker_tib_to_ground=[MK_static.MM(is,:);MK_static.LM(is,:);MK_static.TT(is,:)];
    marker_tib_to_ground=marker_tib_to_ground';
    
    %estimate tibia pose by rigid registration
    [R_tib_guess,T_tib_tra_guess]=svdm(marker_in_tib_ana_ref(1:3,:),marker_tib_to_ground);
    T_tib_guess=[R_tib_guess, T_tib_tra_guess; 0 0 0 1;];
    GeS_tib_guess=GeS_Compute_Coordinates_foot(T_tib_guess,true);
    
    %compute the synergy based kinematic otpimizing the position of the tibia
    %and the 4 synergy coeff that minimize marker error
    initial_guess=[GeS_tib_guess(1);GeS_tib_guess(2);GeS_tib_guess(3);GeS_tib_guess(4);GeS_tib_guess(5);GeS_tib_guess(6);x_opt_i(7:11)];
    J = @(x) (Markers_squared_error(x,scaled_MK_ana,MK_static,scaled_SYN,is,false));
    [x_opt_i,fval] = fmincon(J,initial_guess,[],[]);
    RMSE(is) = sqrt(fval);
    x_opt=[x_opt; x_opt_i';];
end

%find the average foot posture in the static trial
static_opt_posture_pre_toes = mean(x_opt);

T_TI2G = T_Move2Position_foot(static_opt_posture_pre_toes(1:6),true);
T_TATI = T_Move2Position_foot(scaled_SYN.u_ankle(1:6)',false);
T_NATA = T_Move2Position_foot(scaled_SYN.u_foot(7:12)',false);
T_M1NA = T_Move2Position_foot(scaled_SYN.u_foot(37:42)',false);
T_T1M1 = T_Move2Position_foot(scaled_SYN.u_toes(1:6)',true);

T_T12G = T_TI2G*T_TATI*T_NATA*T_M1NA*T_T1M1;

avg_MK_static.PM = [mean(MK_static.PM),1];

exp_PM_in_T1 = inv(T_T12G)*[avg_MK_static.PM]';


%thumb scaling factor
D9 = norm(exp_PM_in_T1(1:3));
d9 = norm(MK_ana.PM(1:3));

scaling_factor_thumb = D9/d9

T_thumb_scaling = diag([scaling_factor_thumb,scaling_factor_thumb,scaling_factor_thumb]);
T_thumb_scaling4x4 = [T_thumb_scaling,[0 0 0]';[0,0,0,1]];

%scale the toes synergies
for k=4:6:30
    scaled_SYN.u_toes(k:k+2)=scaling_factor_thumb*SYN.u_toes(k:k+2);
    scaled_SYN.v_toes(k:k+2)=scaling_factor_thumb*SYN.v_toes(k:k+2);
end

%scale the toe marker
scaled_MK_ana.PM = (T_thumb_scaling4x4*MK_ana.PM')';

%scale the contact spheres
CS_ana_tmp = CS_ana;

% set the radius to 1 to use it as homegeneus coordinates of sphere centers
CS_avg_names = fieldnames(CS_ana_tmp);
    
for k = 1:numel(CS_avg_names)
    cs_avg = CS_avg_names{k};
    CS_ana_tmp.(cs_avg)(4)=1;
end

scaled_CS_ana.T1p = (T_thumb_scaling4x4*CS_ana_tmp.T1p')';
scaled_CS_ana.T1a = (T_thumb_scaling4x4*CS_ana_tmp.T1a')';
scaled_CS_ana.T2p = (T_thumb_scaling4x4*CS_ana_tmp.T2p')';
scaled_CS_ana.T2a = (T_thumb_scaling4x4*CS_ana_tmp.T2a')';
scaled_CS_ana.T3p = (T_thumb_scaling4x4*CS_ana_tmp.T3p')';
scaled_CS_ana.T3a = (T_thumb_scaling4x4*CS_ana_tmp.T3a')';
scaled_CS_ana.T4p = (T_thumb_scaling4x4*CS_ana_tmp.T4p')';
scaled_CS_ana.T4a = (T_thumb_scaling4x4*CS_ana_tmp.T4a')';
scaled_CS_ana.T5p = (T_thumb_scaling4x4*CS_ana_tmp.T5p')';
scaled_CS_ana.T5a = (T_thumb_scaling4x4*CS_ana_tmp.T5a')';

scaled_CS_ana.T1p(4) = mean(diag(T_thumb_scaling))*CS_ana.T1p(4);
scaled_CS_ana.T1a(4) = mean(diag(T_thumb_scaling))*CS_ana.T1a(4);
scaled_CS_ana.T2p(4) = mean(diag(T_thumb_scaling))*CS_ana.T2p(4);
scaled_CS_ana.T2a(4) = mean(diag(T_thumb_scaling))*CS_ana.T2a(4);
scaled_CS_ana.T3p(4) = mean(diag(T_thumb_scaling))*CS_ana.T3p(4);
scaled_CS_ana.T3a(4) = mean(diag(T_thumb_scaling))*CS_ana.T3a(4);
scaled_CS_ana.T4p(4) = mean(diag(T_thumb_scaling))*CS_ana.T4p(4);
scaled_CS_ana.T4a(4) = mean(diag(T_thumb_scaling))*CS_ana.T4a(4);
scaled_CS_ana.T5p(4) = mean(diag(T_thumb_scaling))*CS_ana.T5p(4);
scaled_CS_ana.T5a(4) = mean(diag(T_thumb_scaling))*CS_ana.T5a(4);



%---- retroproject the experimental markers on the fitted and scaled model
% fit the scaled model to the static trial by SB-MKO
x_opt=[];
x_opt_i = [0,0,0,0,0,0,0,0,0,0,0]';
[m,n] = size(MK_static.CA);

%MKO
for is = 1:m
    is/m*100 %processing percentage
    % inizialitation
    marker_in_tib_ana_ref=[scaled_MK_ana.MM;scaled_MK_ana.LM;scaled_MK_ana.TT];
    marker_in_tib_ana_ref=marker_in_tib_ana_ref';

    x_opt_i = [0,0,0,0,0,0,0,0,0,0,0]';

    % prepare data for the inizialization of the tibia pose
    marker_tib_to_ground=[MK_static.MM(is,:);MK_static.LM(is,:);MK_static.TT(is,:)];
    marker_tib_to_ground=marker_tib_to_ground';

    %estimate tibia pose by rigid registration
    [R_tib_guess,T_tib_tra_guess]=svdm(marker_in_tib_ana_ref(1:3,:),marker_tib_to_ground);
    T_tib_guess=[R_tib_guess, T_tib_tra_guess; 0 0 0 1;];
    GeS_tib_guess=GeS_Compute_Coordinates_foot(T_tib_guess,true);

    %compute the synergy based kinematic otpimizing the position of the tibia
    %and the 4 synergy coeff that minimize marker error
    initial_guess=[GeS_tib_guess(1);GeS_tib_guess(2);GeS_tib_guess(3);GeS_tib_guess(4);GeS_tib_guess(5);GeS_tib_guess(6);x_opt_i(7:11)];
    J = @(x) (Markers_squared_error(x,scaled_MK_ana,MK_static,scaled_SYN,is,false));
    [x_opt_i,fval] = fmincon(J,initial_guess,[],[]);
    RMSE(is) = sqrt(fval);
    x_opt=[x_opt; x_opt_i';];
end

%back project the average markers
static_opt_posture = mean(x_opt);
static_error_fitting = mean(RMSE)

avg_MK_static.CA = [mean(MK_static.CA),1];
avg_MK_static.PT = [mean(MK_static.PT),1];
avg_MK_static.ST = [mean(MK_static.ST),1];
avg_MK_static.TN = [mean(MK_static.TN),1];

avg_MK_static.FMB =[mean(MK_static.FMB),1];
avg_MK_static.FMH =[mean(MK_static.FMH),1];
avg_MK_static.SMB =[mean(MK_static.SMB),1];
avg_MK_static.SMH =[mean(MK_static.SMH),1];
avg_MK_static.VMB =[mean(MK_static.VMB),1];
avg_MK_static.VMH =[mean(MK_static.VMH),1];

avg_MK_static.PM = [mean(MK_static.PM),1];
avg_MK_static.MM = [mean(MK_static.MM),1];
avg_MK_static.LM = [mean(MK_static.LM),1];
avg_MK_static.TT = [mean(MK_static.TT),1];


% ---- correcting the toes synergy to have parallel toes in neutral pose--
if toes_adjusting == true

    %MKO without the big toe
    x_opt=[];
    for is = 1:m
        is/m*100 %processing percentage
        
        initial_guess = static_opt_posture;
        x_opt_i = [0,0,0,0,0,0,0,0,0,0,0]';
        %compute the synergy based kinematic otpimizing the position of the tibia
        %and the 4 synergy coeff that minimize marker error
        J = @(x) (Markers_squared_error(x,scaled_MK_ana,MK_static,scaled_SYN,is,true));
        [x_opt_i,fval] = fmincon(J,initial_guess,[],[]);
        RMSE(is) = sqrt(fval);
        x_opt=[x_opt; x_opt_i;];
    end

    static_opt_posture = mean(x_opt);
    static_opt_posture(11)=initial_guess(11);
   
    [static_BigToe_flexion,new_scaled_SYN,new_scaled_MK_ana_PM] = Toes_adjusting(MK_static,static_opt_posture,scaled_MK_ana,scaled_CS_ana,scaled_SYN);

    static_opt_posture(11) = static_BigToe_flexion;
    scaled_SYN = new_scaled_SYN;
    scaled_MK_ana.PM = new_scaled_MK_ana_PM;
end

%reproject the exp marker  
scaled_MK_ana = Marker_back_projection(avg_MK_static,static_opt_posture,scaled_SYN); 

%save final markers, contact spheres, and synergies
save([out_folder side '\scaled_MK_ana.mat'],"scaled_MK_ana");
save([out_folder side '\scaled_CS_ana.mat'],"scaled_CS_ana");
save([out_folder side '\scaled_SYN.mat'],"scaled_SYN");


%scale and save all the bones
%create a structure to pass all the data
param.in_folder = generic_model_folder;
param.side = side;
param.out_folder = out_folder;
param.scaled_SYN = scaled_SYN;
param.T_tib_scaling = T_tib_scaling;
param.T_foot_scaling = T_foot_scaling;
param.T_thumb_scaling = T_thumb_scaling;
param.x = static_opt_posture_pre_toes;

scaled_and_save_bone_STL(param);