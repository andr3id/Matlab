% GENERAZIONE DI UN SEGNALE RANDOM A PARTIRE DALLA SUA PSD
% =========================================================

clear all

% caratteristiche del segnale da costruire:
T = 60;                                                 % durata del segnale (s)
fs = 2000;                                              % freq. di campionamento (Hz)

deltat = 1/fs;
N = T/deltat;                                           % n° di punti del segnale y da costruire (=n° di punti dello spettro double side)
deltaf = 1/T;

% PSD single side del segnale da costruire:
f = 0:deltaf:fs/2;                                      % frequenze della psd single side (il limite superiore del vettore delle frequenze single side è la freq. di Nyquist (=fs/2))

PSD = zeros(1,length(f));
PSD(1:findclosest(f,300)) = 5;                          % (m/s^2)^2/Hz
PSD(findclosest(f,300):findclosest(f,600)) = 100;       % (m/s^2)^2/Hz
PSD(findclosest(f,600):end) = 2;                        % (m/s^2)^2/Hz


% costruzione dello spettro double side:
fDoubleSide = 0:deltaf:fs;                              % frequenze dello spettro double side (il limite superiore è la frequenza di campionamento e il passo deltaf rimane lo stesso)
PSDDoubleSide = [PSD(1) PSD(2:end)/2 fliplr(PSD(2:end))/2];
NDoubleSide = length(fDoubleSide);
absSpectrum = sqrt(deltaf*PSDDoubleSide);
rand_Phase = rand(1,round((N-1)/2))*2*pi-pi;            % valori random fra +/- pi da usare per costruire il vettore delle fasi
phaseSpectrum = [0 rand_Phase  -fliplr(rand_Phase)];    % vettore delle fasi
Spectrum = absSpectrum.*exp(1i*phaseSpectrum);      

% vettore tempo e segnale y:
t = 0:deltat:T;
y = ifft(Spectrum)*NDoubleSide;

% statistiche e plot vari:
mu = mean(y)
var = var(y)
sigma = sqrt(var)
skewness = skewness(y)
kurtosis = kurtosis(y)
rms = rms(y)
var_from_PSDSingleSide = deltaf*trapz(PSD)              % deve essere = var(y)
var_from_PSDDoubleSide = deltaf*trapz(PSDDoubleSide)    % deve essere = var_from_PSDSingleSide = var(y)


figure, plot(t,y), grid on, xlabel('s'), ylabel('m/s^2')
figure, plotGaussianOverHistogram(y,mu,sigma);

