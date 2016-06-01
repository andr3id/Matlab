% SCRIPT DI GENERAZIONE DI UN SEGNALE SWEEP SINE E CALCOLO DEI RELATIVI
% ERS/FDS
% ======================================================================

clear all

% *********** generazione dello sweep sine:***********
T = 1200;                       % durata del segnale (s)
fs = 1000;                      % frequenza di campionamento (Hz)
f1 = 20;                        % freq. iniziale dello sweep
f2 = 100;                       % freq. finale dello sweep
x2punti_m = 5;                  % ampiezza dell'accelerazione imposta dalla tavola vibrante
t = 0:1/fs:T;                   % vettore dei tempi
x = chirp(t,f1,T,f2);           % sweep di accelerazione imposta dalla tavola vibrante

plot(t,x), grid on, xlabel('s'), ylabel('m/s^2')


% *********** CARATTERISTICHE DEL SISTEMA SDOF:***********
zita = 0.05;
bWohler = 10;                   % coefficiente angolare della curva di Wohler
K = 1;                          % costante di proporzionalità spostamento-tensioni
C = 1;                          % costante di proporzionalità della curva di Basquin
f0 = 1:5:2000;                  % vettore delle possibili frequenze naturali del sistema SDOF


% *********** CALCOLO DI ERS/FDS:***********

ERS = ERSSweepSine(zita, f0, f1 ,f2 ,x2punti_m);
FDS = FDSSweepSine(x2punti_m, zita, K, C, bWohler, f0, f1, f2, T, t);

figure, plot(f0,ERS), grid on, xlabel('Natural frequency (Hz)'), ylabel('ERS')
figure, loglog(f0,FDS), grid on, xlabel('Natural frequency (Hz)'), ylabel('FDS')
