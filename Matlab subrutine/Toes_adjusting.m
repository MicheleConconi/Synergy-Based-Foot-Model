function [static_BigToe_flexion,new_scaled_SYN,new_scaled_MK_ana_PM] = toes_adjusting(MK_static,static_opt_posture,scaled_MK_ana,scaled_CS_ana,scaled_SYN)
% trovo la sinergia del pollice che minimizza l'errore
% memorizzo la posizione del marker di modello così trovata
% poi correggo la flessioen delle dita: per questo, stimo la verticale dai
% marker sperimentali e impongo che l'altezza delle sfere di contatto delle
% dita si pari al raggio in quella direzione.
% a questo punto retroproietto il marker di modello di alluce, avendo
% corretto per il contatto dita piede.
% devo infine correggere il varismo. qui correggo la posa media in AA fino
% a minimizzare la distanza dal marker sperimentale.
% infine retroproietto il marker sperimentale

    %-------------------------------------------
    %initialize the foot posture

    %tibia
    T_TI2G=T_Move2Position_foot([static_opt_posture(1) static_opt_posture(2) static_opt_posture(3) static_opt_posture(4) static_opt_posture(5) static_opt_posture(6)],true);
    %ankle
    p_ankle=(scaled_SYN.u_ankle + static_opt_posture(7)*scaled_SYN.v_ankle)';
    %foot
    p_foot=(scaled_SYN.u_foot + static_opt_posture(8)*scaled_SYN.v1_foot + static_opt_posture(9)*scaled_SYN.v2_foot + static_opt_posture(10)*scaled_SYN.v3_foot)';
    %toes
    p_toes=(scaled_SYN.u_toes + static_opt_posture(11)*scaled_SYN.v_toes)';
    
    T_TATI = T_Move2Position_foot(p_ankle(1:6),false);
    T_NATA = T_Move2Position_foot(p_foot(7:12),false);
    
    T_M1NA = T_Move2Position_foot(p_foot(37:42),false);
    T_M2NA = T_Move2Position_foot(p_foot(43:48),false);
    T_M3NA = T_Move2Position_foot(p_foot(49:54),false);
    T_M4NA = T_Move2Position_foot(p_foot(55:60),false);
    T_M5NA = T_Move2Position_foot(p_foot(61:66),false);

    T.M12G = T_TI2G*T_TATI*T_NATA*T_M1NA;
    T.M22G = T_TI2G*T_TATI*T_NATA*T_M2NA;
    T.M32G = T_TI2G*T_TATI*T_NATA*T_M3NA;
    T.M42G = T_TI2G*T_TATI*T_NATA*T_M4NA;
    T.M52G = T_TI2G*T_TATI*T_NATA*T_M5NA;

    avg_MK_static.CA = mean(MK_static.CA);
    avg_MK_static.PT = mean(MK_static.PT);
    avg_MK_static.ST = mean(MK_static.ST);
    avg_MK_static.TN = mean(MK_static.TN);
        
    avg_MK_static.FMB =mean(MK_static.FMB);
    avg_MK_static.FMH =mean(MK_static.FMH);
    avg_MK_static.SMB =mean(MK_static.SMB);
    avg_MK_static.SMH =mean(MK_static.SMH);
    avg_MK_static.VMB =mean(MK_static.VMB);
    avg_MK_static.VMH =mean(MK_static.VMH);
        
    avg_MK_static.PM = mean(MK_static.PM);
    avg_MK_static.MM = mean(MK_static.MM);
    avg_MK_static.LM = mean(MK_static.LM);
    avg_MK_static.TT = mean(MK_static.TT);

    %---------------------------------------------
    %optimize big toe marker fitting
    IG_big_toe_flex = static_opt_posture(11);
    J = @(x1) (BigToe_flexion_squared_error(x1,scaled_MK_ana,avg_MK_static,scaled_SYN,T));
    [x_opt] = fmincon(J,IG_big_toe_flex,[],[]);

    static_opt_posture(11) = x_opt;
    static_BigToe_flexion = x_opt;

    %update the current orientation of the toes
    p_toes=(scaled_SYN.u_toes + static_opt_posture(11)*scaled_SYN.v_toes)';

    T_T1M1 = T_Move2Position_foot(p_toes(1:6),true);
    T_T2M2 = T_Move2Position_foot(p_toes(7:12),true);
    T_T3M3 = T_Move2Position_foot(p_toes(13:18),true);
    T_T4M4 = T_Move2Position_foot(p_toes(19:24),true);
    T_T5M5 = T_Move2Position_foot(p_toes(25:30),true);
    
    T12G = T.M12G*T_T1M1;
    T22G = T.M22G*T_T2M2;
    T32G = T.M32G*T_T3M3;
    T42G = T.M42G*T_T4M4;
    T52G = T.M52G*T_T5M5;

    %------------------------------------------------
    %correct the flexion of the toes to that the anterior contact spheres
    %are in contact with the ground

    %store the optimal location of the marker of the big toe for further
    %retroprojection.
    opt_PM = T12G*scaled_MK_ana.PM';

    %estimate the vertical direction by its index
    n = cross(avg_MK_static.FMH(1:3)-avg_MK_static.CA(1:3),avg_MK_static.VMH(1:3)-avg_MK_static.CA(1:3));
    n = n/norm(n);
    for I=1:3
        n(I)=norm(n(I))
    end
    [M,vertical] = max(n);

    %optimize big toe marker fitting
    IG_toes_flexion = [0,0,0,0,0];
    J = @(x2) (Toes_flexion(x2,static_opt_posture,scaled_CS_ana,scaled_SYN,T,vertical));
    [x_opt,fval] = fmincon(J,IG_toes_flexion,[],[]);

    scaled_SYN.u_toes(1)  = scaled_SYN.u_toes(1)  + x_opt(1);
    scaled_SYN.u_toes(7)  = scaled_SYN.u_toes(7)  + x_opt(2);
    scaled_SYN.u_toes(13) = scaled_SYN.u_toes(13) + x_opt(3);
    scaled_SYN.u_toes(19) = scaled_SYN.u_toes(19) + x_opt(4);
    scaled_SYN.u_toes(25) = scaled_SYN.u_toes(25) + x_opt(5);


    %back project the big toe marker on the optimized toes flexion
    p_toes=(scaled_SYN.u_toes + static_opt_posture(11)*scaled_SYN.v_toes)';

    T_T1M1 = T_Move2Position_foot(p_toes(1:6),true);
    new_scaled_MK_ana_PM = (inv(T.M12G*T_T1M1)*opt_PM)';
    scaled_MK_ana.PM = new_scaled_MK_ana_PM;

    %optimize the big toe varus/valgus
    %optimize big toe marker fitting
    IG_big_abd = 0;
    J = @(x3) (BigToe_varus_squared_error(x3,scaled_MK_ana,avg_MK_static,static_opt_posture,scaled_SYN,T));
    [x_opt,fval] = fmincon(J,IG_big_abd,[],[]);

    scaled_SYN.u_toes(3)  = scaled_SYN.u_toes(3)  + x_opt;

    new_scaled_SYN = scaled_SYN;
end


%-------------------------------------------
function [err_PM]=BigToe_flexion_squared_error(x,scaled_MK_ana,avg_MK_static,scaled_SYN,T)
    p_toes=(scaled_SYN.u_toes + x*scaled_SYN.v_toes)';
    T_T1M1 = T_Move2Position_foot(p_toes(1:6),true);
    
    T = T.M12G*T_T1M1;
    
    err_PM=norm( [avg_MK_static.PM,1]' -T*scaled_MK_ana.PM')^2;
end


function [Err] = Toes_flexion(x,static_opt_posture,scaled_CS_ana,scaled_SYN,T,vertical)

    mod_scaled_SYN = scaled_SYN;
    mod_scaled_SYN.u_toes(1)  = scaled_SYN.u_toes(1)  + x(1);
    mod_scaled_SYN.u_toes(7)  = scaled_SYN.u_toes(7)  + x(2);
    mod_scaled_SYN.u_toes(13) = scaled_SYN.u_toes(13) + x(3);
    mod_scaled_SYN.u_toes(19) = scaled_SYN.u_toes(19) + x(4);
    mod_scaled_SYN.u_toes(25) = scaled_SYN.u_toes(25) + x(5);

    %update the current orientation of the toes
    p_toes=(mod_scaled_SYN.u_toes + static_opt_posture(11)*mod_scaled_SYN.v_toes)';

    T_T1M1 = T_Move2Position_foot(p_toes(1:6),true);
    T_T2M2 = T_Move2Position_foot(p_toes(7:12),true);
    T_T3M3 = T_Move2Position_foot(p_toes(13:18),true);
    T_T4M4 = T_Move2Position_foot(p_toes(19:24),true);
    T_T5M5 = T_Move2Position_foot(p_toes(25:30),true);

    T_T12G = T.M12G*T_T1M1;
    T_T22G = T.M22G*T_T2M2;
    T_T32G = T.M32G*T_T3M3;
    T_T42G = T.M42G*T_T4M4;
    T_T52G = T.M52G*T_T5M5;

    %determine the location of the contact spheres
    moved_ana_CS.T1a(1:4) = (T_T12G*[scaled_CS_ana.T1a(1:3),1]')';
    moved_ana_CS.T2a(1:4) = (T_T22G*[scaled_CS_ana.T2a(1:3),1]')';
    moved_ana_CS.T3a(1:4) = (T_T32G*[scaled_CS_ana.T3a(1:3),1]')';
    moved_ana_CS.T4a(1:4) = (T_T42G*[scaled_CS_ana.T4a(1:3),1]')';
    moved_ana_CS.T5a(1:4) = (T_T52G*[scaled_CS_ana.T5a(1:3),1]')';

    %find the difference between the hight with respect to the vertical
    %direction and the sphere radius.

    err(1) = norm(moved_ana_CS.T1a(vertical) - scaled_CS_ana.T1a(4));
    err(2) = norm(moved_ana_CS.T2a(vertical) - scaled_CS_ana.T2a(4));
    err(3) = norm(moved_ana_CS.T3a(vertical) - scaled_CS_ana.T3a(4));
    err(4) = norm(moved_ana_CS.T4a(vertical) - scaled_CS_ana.T4a(4));
    err(5) = norm(moved_ana_CS.T5a(vertical) - scaled_CS_ana.T5a(4));

    Err=sum(err);
end


function [err_PM]=BigToe_varus_squared_error(x,scaled_MK_ana,avg_MK_static,static_opt_posture,scaled_SYN,T)

    mod_scaled_SYN = scaled_SYN;
    mod_scaled_SYN.u_toes(3)  = scaled_SYN.u_toes(3)  + x;

    p_toes=(mod_scaled_SYN.u_toes + static_opt_posture(11)*scaled_SYN.v_toes)';
    T_T1M1 = T_Move2Position_foot(p_toes(1:6),true);
    
    Topt = T.M12G*T_T1M1;
    x
    err_PM=norm( [avg_MK_static.PM';1] -Topt*scaled_MK_ana.PM')^2
end