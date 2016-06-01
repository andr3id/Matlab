% SCRIPT PER LA GENERAZIONE DI UNO SWEPT COSINE E SUE DERIVATE
% ===========================================================

clear all

fs = 1000;                  % frequenza di campionamento (Hz)
T = 4;                      % durata del segnale (s)
f0 = 2;                     % frequenza iniziale del segnale (Hz)
f1 = 15;                    % frequenza finale del segnale (Hz)
A = 3;                      % ampiezza del segnale
t = 0:1/fs:T;               % vettore del tempo

% formula analitica del coseno sweepato fra le frequenze f0 e f1
k = (f1-f0)/T;              % coefficiente angolare della retta della variazione della frequenza nel tempo
f_t = k/2*t+f0;             % retta della variazione della frequenza nel tempo
y = A*cos(2*pi*f_t.*t);     % equazione dello swept cosine

% velocità nel tempo
ypunto = -A*sin(2*pi*f0*t+k*pi*t.^2).*(2*pi*f0+2*k*pi*t);

% accelerazione nel tempo
y2punti = -2*pi*A*(2*pi*(f0+k*t).^2.*cos(2*pi*f0*t+k*pi*t.^2)+k*sin(2*pi*f0*t+k*pi*t.^2));


subplot(3,1,1)
plot(t,y), grid on, xlabel('s'), ylabel('m'), title('spostamento')

subplot(3,1,2)
plot(t,ypunto), grid on, xlabel('s'), ylabel('m/s'), title('velocità')

subplot(3,1,3)
plot(t,y2punti), grid on, xlabel('s'), ylabel('m/s^2'), title('accelerazione')
