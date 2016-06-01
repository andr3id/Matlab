% FDS single sinusoid
% ==================================================================

clear all

% sollecitazione sinusoidale
f = 10;                 % frequenza 10 Hz
x2punti_m = 10;         % ampiezza 10 m/s^2
T = 1;                  % durata 1s

fs = 1000;              % freq. campionamento
t = 0:1/fs:T;           % vettore del tempo
x2punti = x2punti_m*sin(2*pi*f*t);

plot(t,x2punti), grid on, xlabel('s'), ylabel('m/s^2')

% caratteristiche del sistema a 1 gdl
zita = 0.05;            % fattore di smorzamento
K = 1;                  % coefficiente di proporzionalità
C = 1;                  % coefficiente di proporzionalità
b = 8;                  % pendenza della curva di Wholer

Q = 1/(2*zita);

% calcolo del danneggiamento (eq.3.9 Lalanne vol.5 (2009))
f0_variable = 0:0.1:50;
D = K^b/C*f*T*x2punti_m^b./((2*pi*f0_variable).^(2*b).*((1-(f./f0_variable).^2).^2+(f./(Q*f0_variable)).^2).^(b/2));

figure
plot(f0_variable,D), grid on
xlabel('Hz'), ylabel('Danneggiamento'), title('FDS')