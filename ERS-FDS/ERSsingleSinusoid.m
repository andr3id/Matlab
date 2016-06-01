% ESEMPIO ERS PER SOLLECITAZIONE SINUSOIDALE
% ================================================

clear all

% sollecitazione sinusoidale
f = 10;                 % frequenza 10 Hz
x2punti_m = 10;         % ampiezza 10 m/s^2
T = 4;                  % durata 4s

fs = 1000;              % freq. campionamento 1kHz
t = 0:1/fs:T;           % vettore del tempo
x2punti = x2punti_m*sin(2*pi*f*t);

plot(t,x2punti), grid on, xlabel('s'), ylabel('m/s^2')

% caratteristiche del sistema a 1 gdl
zita = 0.05;            % fattore di smorzamento

Q = 1/(2*zita);

% calcolo dell'Extreme Response Spectrum
f0_variable = 0:0.1:30;                                                     % vettore delle frequenze naturali possibili
                                                                            % (si assume che la combinazione di valori m,c,k del sistema sia tale che al variare della frequenza naturale lo smorzamento zita rimane costante)
ERS = x2punti_m./sqrt((1-(f./f0_variable).^2).^2+(f./(Q*f0_variable)).^2);  % solo f0 è variabile, Q rimane costante perché zita rimane costante

figure
plot(f0_variable,ERS, f0_variable,-ERS), grid on
xlabel('frequenza naturale (Hz)'), ylabel('m/s^2'), title('ERS')
