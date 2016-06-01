% SCRIPT DI GENERAZIONE DI UN SEGNALE RANDOM GAUSSIANO NARROW BAND E
% CALCOLO DEI RELATIVI ERS/FDS
% ======================================================================

clear all

% *********** generazione del segnale gaussiano narrowband x(t):***********
% il segnale lo ottengo costruendo un vettore di valori random gaussiani e
% applicando un filtro passabanda a una banda stretta di frequenze

T = 4;                              % durata del segnale (s)
fs = 1000;                          % frequenza di campionamento (Hz)
fmin = 130;                         % freq. minima per il filtro passabanda
fmax = 140;                         % freq. max per il passabanda

t = 0:1/fs:T;                       % vettore dei tempi
N = length(t);
x2punti = randn(1,N);                           % segnale gaussiano broad band della forzante (accelerazione della tavola vibrante)
x2punti_filt = bandPass(x2punti,t,fmin,fmax);   % filtro con il passabanda il segnale

plot(t,x2punti, t,x2punti_filt), grid on, xlabel('s'), ylabel('m/s^2')
legend('accel. tavola random broadband','accel. tavola random narrowband')

% ************************************************************************
% NOTA:
% la distribuzione statistica del segnale filtrato (h = histogram(x2punti_filt))
% è ancora gaussiana perché il segnale filtrato può essere visto come la
% somma di alcune sinusoidi, dunque la sua distribuzione statistica è data
% dalla convoluzione delle distribuzioni statistiche delle sinusoidi che lo
% compongono!
% La distribuzione di una sinusoide (h = histogram(sin(2*pi*f*t))) non è
% una gaussiana, tuttavia la convoluzione di un certo numero di
% distribuzioni dà una gaussiana (teorema del limite centrale)
% ************************************************************************


% ********** CALCOLO DELLA PSD DEL SEGNALE DELLA FORZANTE (x2punti_filt) ***********
Nw = 1024;                      % numero di punti della finestra di Hanning
overlapPercent = 50;            % percentuale di overlap delle finestre
[PSD, fwelch] = PSDWelch(x2punti_filt,fs,1024,50);


% ********** CALCOLO DI ERS/FDS **********
zita = 0.05;                    % fattore di smorzamento
f0 = 1:0.1:500;                 % vettore delle possibili freq. nat. del sistema SDOF
C = 1;                          % cost. di proporzionalità per l'FDS
K = 1;                          % cost. di proporzionalità per l'FDS
bWohler = 7;                    % coefficiente angolare della curva do Wohler

ERS = ERSGaussianLoadNarrowband(zita,T,f0,PSD,fwelch);
FDS = FDSGaussianLoadNarrowband(zita,T,K,C,bWohler,f0,PSD,fwelch);

figure, plot(f0,ERS), grid on, xlabel('f0 (Hz)'), ylabel('ERS')
figure, plot(f0,FDS), grid on, xlabel('f0 (Hz)'), ylabel('FDS')



