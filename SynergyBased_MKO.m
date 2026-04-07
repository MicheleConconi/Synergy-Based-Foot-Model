% SYNERGY-BASED MULTYBODY KINEMATIC OPTIMIZATION (SB-MKO) FOR THE FOOT -
% SB-MKO

% Code by Michele Conconi, University of Bologna, 2026

% The code assume the generic model of the foot has already been scaled on
% a static trial in a previous step using Anysotropic_scaling.m

% Conconi, M., Sancisi, N., Leardini, A., & Belvedere, C. (2024). The foot 
% and ankle complex as a four degrees‐of‐freedom system: Kinematic coupling 
% among the foot bones. Journal of Orthopaedic Research.

% ------------------- INPUT ---------------------
% The code take as an input a .trc file describing the coordinates of the
% foot marker in a dynamic trial the side (left - L, or right - R) to be 
% analyzed.

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

% The code also assumes to be having access to the subfolder "Scaled
% model", which contains all the data for the considered foot as computed 
% at the previous step. Specifically, the folder must contain:
% - the scaled foot an ankle synergies
% - the scaled anatomical markers, resulting from backprojection of
% experimental ones after scaling and fitting the model on the static trial
% - the scaled foot contact spheres
% - scaled stl files of the bones

% The code will compute as output:
%  - the absolute kinematic of each bone
%  - the variation of synergy coefficients
%  - the trajectory of the model markers
%  - the trajectory of contact spheres approximating bone/ground interaction



%% ---------- Read data and set parameters --------------------------
clear all
clc

% set the folder for data and input
dynamic_trial = char('motion data\walking.trc'); %where the .trc static file is
side = 'R'; %select the leg that we want to build the model for
Units = 'm'; %coordinate can be expressed in meter (m), or millimeter (mm)

model_folder = char('Scaled model\');
out_folder = char(['Scaled model\' side '\SB_MKO\']);

addpath('.\Matlab subrutine\');

%loading all the files to be scaled: marker in ana, contact spheres in ana,
%synergies

% we assume that the average foot posture can be close enough to the
% neutral one to be used for scaling

% trc = readTRC(dynamic_trial);

load("C:\Users\michele.conconi3\OneDrive - Alma Mater Studiorum Università di Bologna\Arthrone_Legs\Desktop\Synergy based MKO - anisotropic scaling\motion data\999999m018\20181024\Right\export_Michele\24102018_999999m018_PAD_Dyn_Right_03.mat")
MK_static = marker_italy.stat;
MK_dynamic = marker_italy.dyn;
Units = 'm';
side = 'R';

load([model_folder side '\scaled_MK_ana.mat']);
load([model_folder side '\scaled_CS_ana.mat']);
load([model_folder side '\scaled_SYN.mat']);


% converts experimental data in mm
if Units == 'm'
    UnitConversion = 1000;
elseif Units == 'mm'
    UnitConversion = 1; 
end

% 
MK_dynamic.TT=  marker_italy.dyn.TT*UnitConversion;
MK_dynamic.LM=  marker_italy.dyn.LM*UnitConversion;
MK_dynamic.MM=  marker_italy.dyn.MM*UnitConversion;
MK_dynamic.CA=  marker_italy.dyn.CA*UnitConversion;
MK_dynamic.PT=  marker_italy.dyn.PT*UnitConversion;
MK_dynamic.ST=  marker_italy.dyn.ST*UnitConversion;
MK_dynamic.VMB= marker_italy.dyn.VMB*UnitConversion;
MK_dynamic.TN=  marker_italy.dyn.TN*UnitConversion;
MK_dynamic.SMB= marker_italy.dyn.SMB*UnitConversion;
MK_dynamic.FMB= marker_italy.dyn.FMB*UnitConversion;
MK_dynamic.VMH= marker_italy.dyn.VMH*UnitConversion;
MK_dynamic.SMH= marker_italy.dyn.SMH*UnitConversion;
MK_dynamic.FMH= marker_italy.dyn.FMH*UnitConversion;
MK_dynamic.PM=  marker_italy.dyn.PM*UnitConversion;

% if side == 'R'
%     MK_dynamic.TT=  trc.Data.RTT*UnitConversion;
%     MK_dynamic.LM=  trc.Data.RLM*UnitConversion;
%     MK_dynamic.MM=  trc.Data.RMM*UnitConversion;
%     MK_dynamic.CA=  trc.Data.RCA*UnitConversion;
%     MK_dynamic.PT=  trc.Data.RPT*UnitConversion;
%     MK_dynamic.ST=  trc.Data.RST*UnitConversion;
%     MK_dynamic.VMB= trc.Data.RVMB*UnitConversion;
%     MK_dynamic.TN=  trc.Data.RTN*UnitConversion;
%     MK_dynamic.SMB= trc.Data.RSMB*UnitConversion;
%     MK_dynamic.FMB= trc.Data.RFMB*UnitConversion;
%     MK_dynamic.VMH= trc.Data.RVMH*UnitConversion;
%     MK_dynamic.SMH= trc.Data.RSMH*UnitConversion;
%     MK_dynamic.FMH= trc.Data.RFMH*UnitConversion;
%     MK_dynamic.PM=  trc.Data.RPM*UnitConversion;
% else
%     MK_dynamic.TT=  trc.Data.LTT*UnitConversion;
%     MK_dynamic.LM=  trc.Data.LLM*UnitConversion;
%     MK_dynamic.MM=  trc.Data.LMM*UnitConversion;
%     MK_dynamic.CA=  trc.Data.LCA*UnitConversion;
%     MK_dynamic.PT=  trc.Data.LPT*UnitConversion;
%     MK_dynamic.ST=  trc.Data.LST*UnitConversion;
%     MK_dynamic.VMB= trc.Data.LVMB*UnitConversion;
%     MK_dynamic.TN=  trc.Data.LTN*UnitConversion;
%     MK_dynamic.SMB= trc.Data.LSMB*UnitConversion;
%     MK_dynamic.FMB= trc.Data.LFMB*UnitConversion;
%     MK_dynamic.VMH= trc.Data.LVMH*UnitConversion;
%     MK_dynamic.SMH= trc.Data.LSMH*UnitConversion;
%     MK_dynamic.FMH= trc.Data.LFMH*UnitConversion;
%     MK_dynamic.PM=  trc.Data.LPM*UnitConversion;
% end



%% ---- processing dynamic data ---------------------------------------

%inizialitation
marker_in_tib_ana_ref=[scaled_MK_ana.MM;scaled_MK_ana.LM;scaled_MK_ana.TT];
marker_in_tib_ana_ref=marker_in_tib_ana_ref';

x_opt=[];
x_opt_i = [0,0,0,0,0,0,0,0,0,0,0]';
[m,n] = size(MK_dynamic.CA);

%MKO
for is = 1:m
    is/m*100 %processing percentage

    % prepare data for the inizialization of the tibia pose 
    marker_tib_to_ground=[MK_dynamic.MM(is,:);MK_dynamic.LM(is,:);MK_dynamic.TT(is,:)];
    marker_tib_to_ground=marker_tib_to_ground';

    %estimate tibia pose by rigid registration
    [R_tib_guess,T_tib_tra_guess]=svdm(marker_in_tib_ana_ref(1:3,:),marker_tib_to_ground);
    T_tib_guess=[R_tib_guess, T_tib_tra_guess; 0 0 0 1;];
    GeS_tib_guess=GeS_Compute_Coordinates_foot(T_tib_guess,true);

    %compute the synergy based kinematic otpimizing the position of the tibia
    %and the 4 synergy coeff that minimize marker error
    initial_guess=[GeS_tib_guess(1);GeS_tib_guess(2);GeS_tib_guess(3);GeS_tib_guess(4);GeS_tib_guess(5);GeS_tib_guess(6);x_opt_i(7:11)];
    J = @(x) (Markers_squared_error(x,scaled_MK_ana,MK_dynamic,scaled_SYN,is,false));
    [x_opt_i,fval] = fmincon(J,initial_guess,[],[]);
    RMSE(is) = sqrt(fval);
    x_opt=[x_opt; x_opt_i';];
end

%plotting the synergies
figure
subplot(5,1,1)
plot(x_opt(:,7))
grid minor
ylabel('ankle flexion')
subplot(5,1,2)
plot(x_opt(:,8))
grid minor
ylabel('foot abduction')
subplot(5,1,3)
plot(x_opt(:,9))
grid minor
ylabel('foot pronation')
subplot(5,1,4)
plot(x_opt(:,10))
grid minor
ylabel('foot arching')
subplot(5,1,5)
plot(x_opt(:,11))
grid minor
ylabel('big toe flexion')
xlabel('frame')
%% saving final motion and markers trajectorie

Comp_MK = Absolute_foot_kinematics_from_synergies(x_opt,scaled_SYN,out_folder,scaled_MK_ana);

save([out_folder 'foot_kinematics.mat'], 'x_opt')
save([out_folder 'exp_markers.mat'], 'MK_dynamic')
save([out_folder 'comp_markers.mat'], 'Comp_MK')

%% Contact spheres

%% computing and saving contact point trajectories

%compute trajectories
CS = Compute_contact_spheres_trajectories(out_folder,scaled_CS_ana);
save([out_folder 'contact_spheres_trajectories.mat'], 'CS')

exp_marker=[MK_dynamic.TT;MK_dynamic.LM;MK_dynamic.MM;MK_dynamic.CA;MK_dynamic.ST;MK_dynamic.FMH;MK_dynamic.VMH;MK_dynamic.PM];
% comp_marker=[Comp_MK.TT;Comp_MK.LM;Comp_MK.MM;Comp_MK.CA;Comp_MK.ST;Comp_MK.FMH;Comp_MK.VMH;Comp_MK.PM];
comp_marker=[Comp_MK.FMH;Comp_MK.PM];

save([out_folder 'exp_marker.txt'], 'exp_marker','-ascii')
save([out_folder 'comp_marker.txt'], 'comp_marker','-ascii')