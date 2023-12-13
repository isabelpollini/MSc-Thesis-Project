%%%% Calcolo forze richieste e cinematica del motore %%%%

%% Dati

l       = -20:0.1:15;                   % Corsa motore lineare
a       = 315 + l;                      % Biella sterzo
b       = 320;                          % Distanza motore-albero
c       = 70;                           % Braccio collare
beta    = 90*pi/180;                    % Angolo geometria

x0      = [beta*180/pi; 100]*pi/180;    % Valori iniziali


%% Soluzione cinematica per ogni valore di a (corsa)

S = zeros(2,length(a));

for ii = 1:length(a)
    F       = @(x) [a(ii)*cos(x(1)) - b*cos(beta) + c*cos(x(2));...
                    a(ii)*sin(x(1)) - b*sin(beta) + c*sin(x(2))];
    sol     = fsolve(F,x0);
    S(:,ii) = sol;
end

alfa    = S(1,:)*180/pi;      % Conversione angoli 
gamma   = S(2,:)*180/pi;
braccio = c*sind(alfa + 180 - gamma);

theta   = 90 - (180 - gamma + alfa);


%% Accelerazione e variazione braccio di sterzo

acc             = [0:0.1:10];               % Accelerazione 
dtheta          = 0.5*pi/180;               % Variazione angolare
t               = sqrt(2.*dtheta./acc);     % Tempo richiesto
ALPHA           = theta;

%% Building dataKin matrix

dataKin         = zeros(6,length(a));
dataKin(1,:)    = a;
dataKin(2,:)    = l;
dataKin(3,:)    = alfa;
dataKin(4,:)    = gamma;
dataKin(5,:)    = braccio;
dataKin(6,:)    = ALPHA;
