%% Definizione Dati Strumenti di misura
i_er_ab     = 0.3/2;                                         % [mm]     incertezza calibro misura reale a e b 
i_er_cd     = 1/2;                                           % [mm]     incertezza calibro misura reale c e d 
i_enc_lin   = 1e-3;                                          % [mm]     incertezza encoder lineare
i_enc       = asin(2*i_enc_lin/71);                          % [rad]    incertezza encoder 
i_dg_ab     = sqrt(0.02^2 + i_er_ab^2);                      % [mm]     incertezza calibro di profondità zero meccanico ruota 
i_dg_cd     = sqrt(0.02^2 + i_er_cd^2);                      % [mm]     incertezza calibro di profondità allineamento struttura 
i_rs        = 0.04;                                          % [mm]     incertezza rettilineità della riga 
i_ro        = 0.05;                                          % [mm]     incertezza run_out disco rigido 
i_ho        = 0.1;                                           % [mm]     incertezza supporti della riga 
i_r         = 0.5;                                           % [mm]     incertezza riga 
i_abs       = 0.04;                                          % [mm]     incertezza rettilineità del supporto del tappeto 
i_ts        = 0.04;                                          % [mm]     incertezza rettilineità della dima 
% i_gm      = 0.01;                                          % [mm]     incertezza parallelismo tra tappeto di gomma e supporto tappeto 

%% Incertezza Calibro totale(a,b,c,d) e riga(x,y)
i_a     = sqrt(i_dg_ab^2 + (i_rs)^2 + i_ro^2 + i_ho^2);            % [mm]     incertezza a  
i_b     = i_a;                                                     % [mm]     incertezza b
i_c     = sqrt(i_dg_cd^2 + (i_abs)^2 + (i_ts)^2);                  % [mm]     incertezza c 
i_d     = i_c;                                                     % [mm]     incertezza d 
i_x     = i_r;                                                     % [mm]     incertezza misura x = incertezza riga 
i_y     = i_x;                                                     % [mm]     incertezza y = incertezza x 

%% Incertezza Forze e posizionamento
portata_cella1  = 50;
portata_cella2  = 250;
i_celle         = 0.0002*portata_cella1*9.81;               % [N]      incertezza Celle catalogo
i_cella_Fz      = 0.0002*portata_cella2*9.81;               % [N]      incertezza Cella Fz catalogo
i_Fw1_teo       = i_celle;                                  % [N]      incertezza Cella Watt 
i_Fw2_teo       = i_celle;                                  % [N]      incertezza Cella Watt 
i_Fs_teo        = i_celle;                                  % [N]      incertezza Cella sterzo 
i_Fz_teo        = i_cella_Fz;                               % [N]      incertezza Cella Fz
i_beta1         = 1*pi/180;                                 % [rad]    incertezza angolo celle Watt 
i_beta2         = 1*pi/180;                                 % [rad]    incertezza angolo celle Watt 

%% Incertezza Coefficienti di correzione camber
i_m     = 0.3;                                               % [-]      incertezza parametro m - correzione camber
i_gamma = 0.2;                                               % [-]      incertezza parametro gamma - correzione camber
i_q     = 0.3;                                               % [-]      incertezza parametro q - correzione camber
i_L     = 1;                                                 % [mm]     incertezza L
i_L2    = 1;                                                 % [mm]     incertezza L2

%% Incertezza Braccio di sterzo
i_bc        = 0.1;                                           % [mm]     incertezza braccio di sterzo               
i_phi_h1    = 0.2;                                           % [mm]     incertezza diametro foro collare
i_phi_b1    = 0.1;                                           % [mm]     incertezza diametro vite collare
i_delta1    = 2*(pi);                                        % [rad]    incertezza angolo vite collare
i_phi_h2    = 0.2;                                           % [mm]     incertezza diametro foro piffero
i_phi_b2    = 0.1;                                           % [mm]     incertezza diametro vite piffero
i_delta2    = 2*(pi);                                        % [rad]    incertezza angolo vite collare
i_h         = 1;                                             % [mm]     incertezza allineamento fori
i_l         = 1;                                             % [mm]     incertezza lunghezza biella sterzo

%% Incertezza Camber
% Rigid
E0r         = 206000;                                         % [MPa]    modulo elastico acciaio
a0cr        = 567;                                            % [mm]     distanza tra i cuscinetti albero
b0cr        = 150;                                            % [mm]     distanza tra cuscinetto inferiore e piastra forcella
e0cr        = 150;                                            % [mm]     lunghezza piastra forcella
d0cr        = 500;                                            % [mm]     lunghezza forcella
f0cr        = 622/2;                                          % [mm]     raggio disco
m0cr        = 19;                                             % [kg]     massa albero + forcella + ruota
g0cr        = 9.81;                                           % [m/s2]
d1_ext0r    = 40;                                             % [mm]     diametro esterno albero
d1_int0r    = 28;                                             % [mm]     diametro interno albero
J10r        = pi/64*(d1_ext0r^4 - d1_int0r^4);                % [mm4]    momento d'inerzia di superficie albero
J20r        = 829440;                                         % [mm4]    momento d'inerzia di superficie piastra superiore forcella (da tesi) 
J30r        = 1.8e6;                                          % [mm4]    momento d'inerzia di superficie piastra laterale forcella (da tesi)
J40r        = pi/64*30^4;                                     % [mm4]    momento d'inerzia di superficie mozzo
J50r        = 1.8e6;                                          % [mm4]    momento d'inerzia di superficie disco

i_a1r   = 20;                                                 % [mm]     incertezza distanza tra i cuscinetti albero      
i_b1r   = 20;                                                 % [mm]     incertezza distanza tra cuscinetto inferiore e piastra forcella
i_d1r   = 20;                                                 % [mm]     incertezza lunghezza forcella
i_e1r   = 20;                                                 % [mm]     lunghezza piastra forcella
i_f1r   = 20;                                                 % [mm]     raggio disco
i_J1r   = 0.1*J10r;                                           % [mm4]    incertezza momento d'inerzia di superficie albero
i_J2r   = 0.1*J20r;                                           % [mm4]    incertezza momento d'inerzia di superficie piastra superiore forcella (da tesi) 
i_J3r   = 0.1*J30r;                                           % [mm4]    incertezza momento d'inerzia di superficie piastra laterale forcella (da tesi)
i_J4r   = 0.1*J40r;                                           % [mm4]    incertezza momento d'inerzia di superficie mozzo
i_J5r   = 0.1*J50r;                                           % [mm4]    incertezza momento d'inerzia di superficie disco

E0d1        = 206000;                                         % [MPa]    modulo elastico acciaio
E0d2        = 70000;
a0cd        = 567;                                            % [mm]     distanza tra i cuscinetti albero
b0cd        = 150;                                            % [mm]     distanza tra cuscinetto inferiore e piastra forcella
e0cd        = 150;                                            % [mm]     lunghezza piastra forcella
d0cd        = 500;                                            % [mm]     lunghezza forcella
f0cd        = 622/2;                                          % [mm]     raggio disco
m0cd        = 19;                                             % [kg]     massa albero + forcella + ruota
g0cd        = 9.81;                                           % [m/s2]
d1_ext0d    = 40;                                             % [mm]     diametro esterno albero
d1_int0d    = 28;                                             % [mm]     diametro interno albero
J10d        = pi/64*(d1_ext0d^4 - d1_int0d^4);                % [mm4]    momento d'inerzia di superficie albero
J20d        = 829440;                                         % [mm4]    momento d'inerzia di superficie piastra superiore forcella (da tesi) 
J30d        = 1.8e6;                                          % [mm4]    momento d'inerzia di superficie piastra laterale forcella (da tesi)
J40d        = pi/64*30^4;                                     % [mm4]    momento d'inerzia di superficie mozzo
J50d        = 1.8e6;                                          % [mm4]    momento d'inerzia di superficie disco

i_a1d       = 20;                                             % [mm]     incertezza distanza tra i cuscinetti albero      
i_b1d       = 20;                                             % [mm]     incertezza distanza tra cuscinetto inferiore e piastra forcella
i_d1d       = 20;                                             % [mm]     incertezza lunghezza forcella
i_e1d       = 20;                                             % [mm]     lunghezza piastra forcella
i_f1d       = 20;                                             % [mm]     raggio disco
i_J1d       = 0.1*J10d;                                       % [mm4]    incertezza momento d'inerzia di superficie albero
i_J2d       = 0.1*J20d;                                       % [mm4]    incertezza momento d'inerzia di superficie piastra superiore forcella (da tesi) 
i_J3d       = 0.1*J30d;                                       % [mm4]    incertezza momento d'inerzia di superficie piastra laterale forcella (da tesi)
i_J4d       = 0.1*J40d;                                       % [mm4]    incertezza momento d'inerzia di superficie mozzo
i_J5d       = 0.1*J50d;                                       % [mm4]    incertezza momento d'inerzia di superficie disco

i_gb        = 0.05*pi/180;                                    % [rad]    incertezza bolla digitale

%% Dati generali

dataVetyt.L               = 1227;                             % [mm]     distanza giunto-Watt                                               
dataVetyt.L2              = 628;                              % [mm]     distanza giunto-albero  
dataVetyt.b               = 70;                               % [mm]     braccio sterzo
dataVetyt.g               = 9.81;                             % [m/s2]   accelerazione di gravità

dataTest.t_duration     = 2.58914;              % Time length of the cut plots [s]
dataTest.m_Watt         = -2.838;               %    Def |   Fz 490 -3.32    |  Fz 400  -2.082;
dataTest.q_Watt         = -3.079;               %    Def |   Fz 490 -0.59    |  Fz 400  -1.042;
dataTest.fcut           = 1;                    % Cut-off frequency of the filter [Hz]
dataTest.fsamp          = 1612.9;               % Sampling frequency [Hz]
